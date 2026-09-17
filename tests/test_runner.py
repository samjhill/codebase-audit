"""End-to-end checks of the shell runner without calling paid coding agents."""

import os
from pathlib import Path
import subprocess
import tempfile
import unittest


RUNNER = Path(__file__).resolve().parents[1] / "run.sh"


class RunnerTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.repo = self.root / "repo"
        self.repo.mkdir()
        self.bin = self.root / "bin"
        self.bin.mkdir()
        subprocess.run(["git", "init", "-q"], cwd=self.repo, check=True)
        subprocess.run(
            ["git", "-c", "user.name=Test", "-c", "user.email=test@example.com",
             "commit", "--allow-empty", "-qm", "initial"],
            cwd=self.repo, check=True,
        )

    def agent(self, name, *, report=True, exit_code=0):
        path = self.bin / name
        body = 'printf "%s\\n" "$@" > "$AUDIT_ARGS_FILE"\n'
        body += 'printf "fixed\\n" > fixed.txt\n'
        if report:
            body += 'mkdir -p .code-audit\nprintf "# Audit\\n" > .code-audit/report.md\n'
        body += f"exit {exit_code}\n"
        path.write_text("#!/usr/bin/env bash\n" + body)
        path.chmod(0o755)

    def run_audit(self, *args):
        env = os.environ.copy()
        env["PATH"] = str(self.bin) + os.pathsep + env["PATH"]
        env["AUDIT_ARGS_FILE"] = str(self.root / "args")
        return subprocess.run(
            ["bash", str(RUNNER), *args], cwd=self.repo, env=env,
            text=True, capture_output=True,
        )

    def test_claude_creates_review_branch_and_report(self):
        self.agent("claude")
        result = self.run_audit("--agent", "claude")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("Audit complete", result.stdout)
        args = (self.root / "args").read_text()
        self.assertTrue(args.startswith("-p\n--permission-mode\nauto\n--output-format\ntext\n"))
        self.assertIn("Write .code-audit/report.md", args)
        self.assertEqual((self.repo / ".code-audit/report.md").read_text(), "# Audit\n")
        branch = subprocess.check_output(
            ["git", "branch", "--show-current"], cwd=self.repo, text=True,
        ).strip()
        self.assertTrue(branch.startswith("audit/"), branch)

    def test_cursor_and_codex_routes(self):
        for agent, binary, prefix in (
            ("cursor", "cursor-agent", "-p\n--force\n--output-format\ntext\n"),
            ("codex", "codex", "exec\n--sandbox\nworkspace-write\n--ephemeral\n"),
        ):
            with self.subTest(agent=agent):
                self.agent(binary)
                result = self.run_audit("--agent", agent, "--no-branch")
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertTrue((self.root / "args").read_text().startswith(prefix))
                (self.repo / "fixed.txt").unlink()
                (self.repo / ".code-audit/report.md").unlink()

    def test_missing_report_is_failure_even_when_agent_exits_zero(self):
        self.agent("claude", report=False)
        result = self.run_audit("--agent", "claude", "--no-branch")
        self.assertEqual(result.returncode, 1)
        self.assertIn("Audit incomplete", result.stderr)
        self.assertNotIn("Audit complete", result.stdout)
        self.assertFalse((self.repo / ".code-audit/report.md").exists())

    def test_agent_failure_and_dirty_tree_are_not_success(self):
        self.agent("claude", exit_code=7)
        result = self.run_audit("--agent", "claude", "--no-branch")
        self.assertEqual(result.returncode, 1)
        self.assertIn("Claude exited with an error", result.stderr)
        (self.repo / "unrelated.txt").write_text("uncommitted\n")
        result = self.run_audit("--agent", "claude")
        self.assertEqual(result.returncode, 1)
        self.assertIn("Working tree must be clean", result.stderr)


if __name__ == "__main__":
    unittest.main()
