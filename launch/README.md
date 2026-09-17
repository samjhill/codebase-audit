# Launch kit

Publish after the one-command runner is on `main` and has been tested in a disposable repository. The posts below are drafts to adapt in Sam's own voice. Do not claim a real bug or result until one has been reproduced and reviewed.

## GitHub repository settings

**Description:** One command to audit a codebase with Cursor, Codex, or Claude Code, apply reviewable fixes, and run it periodically.

**Topics:** `code-audit`, `ai-coding`, `developer-tools`, `automation`, `code-quality`, `cursor`, `codex`, `claude-code`

**Social preview:** Upload `assets/social-preview.jpg` in Settings → General → Social preview. A plain RGB PNG is also available at `assets/social-preview.png`. GitHub does not set either image from a file in the repository.

## Launch post

> One of the most revealing bugs I found while building Codebase Audit was in its own runner.
>
> An agent could exit successfully without writing the audit report. My runner would create a placeholder and print “Audit complete.” That was a green signal for an outcome that had not happened. I reproduced it in a disposable repo, changed the runner to fail when the report is missing, and added a regression test.
>
> That is the thinking behind Codebase Audit: trace the path to the user-visible outcome, separate observation from inference, fix what you can verify, and name what remains unknown. One command runs with Cursor, Codex, or Claude Code and leaves a reviewable branch and report. There are also weekly PR workflow examples and 25 focused prompts.
>
> The self-audit is in the README. I would especially value concrete false positives or cases where the workflow missed the real failure.
>
> https://github.com/samjhill/codebase-audit

## Short developer-community post

> I made Codebase Audit: one command for Cursor, Codex, or Claude Code to trace code paths, apply small verified fixes, run checks, and write a report on a reviewable branch. The design principle: code evidence before confident-sounding advice. Feedback and counterexamples welcome: https://github.com/samjhill/codebase-audit

## Follow-up post after a verified result

Use a real, permission-safe result. Show the question, code path, test or reproduction, smallest fix, and what the first agent answer missed. Redact secrets and customer details. Link the exact prompt and PR or commit. Avoid a victory claim based only on the agent's report.
