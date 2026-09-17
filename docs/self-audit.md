# A small audit of this audit tool

This is a real finding from Codebase Audit's own runner, not a claim about another application or a model benchmark. It shows the standard we want an audit to meet: a path to an incorrect outcome, a reproduction, a minimal fix, and an explicit limit on what the check proves.

## The misleading success

The runner asks the coding agent to write `.code-audit/report.md`. Previously, when an agent exited with status zero without writing that file, the runner created a generic placeholder and printed `Audit complete`. A caller could see a successful command and a report path even though the required audit evidence was missing. This is the same kind of boundary error the [operational truth prompt](../code/operational-truth.md) asks agents to find in other systems.

**Reproduction:** In a disposable Git repository, substitute a CLI that exits zero but does not write the report. The old runner returned zero and created a placeholder. No paid agent or live customer system is involved.

**Fix:** The runner now requires a nonempty report. If it is missing, it prints `Audit incomplete`, shows the current diff status, and exits nonzero. It leaves any agent edits on the audit branch for review.

```text
Before: agent exits 0, no report → runner exits 0, creates placeholder, says “Audit complete”
After:  agent exits 0, no report → runner exits 1, says “Audit incomplete”
```

**Regression check:** `python3 -m unittest discover -s tests -v` runs [the disposable repository test](../tests/test_runner.py), including this missing-report case, successful routes for Cursor, Codex, and Claude, agent failure, and protection of an existing dirty tree. The tests exercise shell control flow with stub CLIs. They do **not** prove that a model will find a bug, that its edits are correct, or that the scheduled workflow will run with your credentials.

The lesson is the product principle: a returned response is not necessarily a completed outcome. Verify the artifact that represents completion, and label the level of evidence behind each check.
