#!/usr/bin/env bash
set -euo pipefail

# Run from the root of the codebase to audit, not from this prompt library.
if [[ "${1:-}" == "--help" ]]; then
  cat <<'HELP'
Usage: bash run.sh [--no-branch]

Run a repository-wide Cursor audit and apply reviewable fixes. Requires git and
an authenticated cursor-agent CLI. By default creates a new codex/audit-* branch.
Use --no-branch only in an isolated CI checkout that will create its own branch.
HELP
  exit 0
fi

no_branch=false
if [[ "${1:-}" == "--no-branch" ]]; then no_branch=true; shift; fi
if [[ $# -ne 0 ]]; then echo "Unknown argument: $1" >&2; exit 2; fi

for binary in git cursor-agent; do
  if ! command -v "$binary" >/dev/null 2>&1; then
    echo "Missing $binary. Install Cursor CLI from https://cursor.com/docs/cli/installation and authenticate with cursor-agent login." >&2
    exit 1
  fi
done

repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "Run this from a git repository." >&2; exit 1;
}
cd "$repo_root"
if [[ -n "$(git status --porcelain)" ]]; then
  echo "Working tree must be clean. Commit or stash your work before running the audit." >&2
  exit 1
fi

if [[ "$no_branch" == false ]]; then
  branch="codex/audit-$(date -u +%Y%m%d-%H%M%S)"
  git switch -c "$branch" >/dev/null
  echo "Working on $branch"
fi

report_dir=.code-audit
mkdir -p "$report_dir"
report_file="$report_dir/report.md"

prompt_file=$(mktemp "${TMPDIR:-/tmp}/code-audit-prompt.XXXXXX")
cat > "$prompt_file" <<'PROMPT'
You are auditing this entire repository to find and fix concrete problems in its existing behavior, code quality, reliability, security, customer journey, tests, dependencies, CI, and operating cost. First map the actual application and choose only categories that apply. Follow repository instructions. Prioritize user-visible failures, security exposure, data loss, incorrect billing or entitlements, and expensive recurring work.

Work in focused passes within this single run:
1. Trace the main user path and the relevant request, state, job, and deployment paths. Identify specific failures or avoidable complexity with file and line evidence. Separate confirmed facts from inferences and unknowns. Check whether "success" means a persisted, user-visible outcome, not merely an accepted request or queued job.
   Look especially for stale or missing source data presented as current; duplicate work after retries; partial completion reported as success; notifications that are wrong, noisy, late, or sent to the wrong audience; and test fixtures or mocks that can be mistaken for live acceptance. Check whether identity and attribution are grounded before source material is treated as customer evidence. Check whether customer-facing generated content can contain unsupported claims or repeat existing work when relevant to this product.
2. Reproduce important findings safely with existing tests, fixtures, mocks, or sandbox data. Do not touch production systems, reveal secrets, or run destructive tests.
3. Apply the smallest practical fixes for findings you can verify. Keep diffs reviewable. Do not perform broad rewrites, major dependency upgrades, schema changes, or changes to public behavior without strong evidence and tests. Leave those as recommendations. Solve the underlying data or state problem before adding an integration or redesigning a UI. Do not silently turn unavailable dependencies into empty successful results.
4. Run the relevant available checks. Inspect your diff for regressions. Do not commit, push, open a PR, or contact external services.

Write .code-audit/report.md with a concise system map, each finding's evidence and impact, fixes made, checks run and their results, unresolved risks, and next actions. Label each check as unit/fixture, integration, staging, or live and state which external dependencies were mocked. A fixture pass cannot claim live acceptance. It is acceptable to report no confirmed findings. Do not invent savings, tests, or certainty. Do not include secrets or private data in the report.
PROMPT
prompt=$(cat "$prompt_file")
rm -f "$prompt_file"

echo "Running Cursor audit. This may take time and use your Cursor plan or API quota."
if ! cursor-agent -p --force --output-format text "$prompt"; then
  echo "Cursor exited with an error. Review its output and the current diff." >&2
  exit 1
fi

if [[ ! -f "$report_file" ]]; then
  {
    echo "# Code audit"
    echo
    echo "The agent did not write a structured report. Review the diff and rerun if needed."
  } > "$report_file"
fi

echo "Audit complete. Review $report_file and the diff before merging."
git status --short
