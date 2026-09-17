# Launch kit

Publish after the one-command runner is on `main` and has been tested in a disposable repository. The posts below are drafts to adapt in Sam's own voice. Do not claim a real bug or result until one has been reproduced and reviewed.

## GitHub repository settings

**Description:** One command to audit a codebase with Cursor, Codex, or Claude Code, apply reviewable fixes, and run it periodically.

**Topics:** `code-audit`, `ai-coding`, `developer-tools`, `automation`, `code-quality`, `cursor`, `codex`, `claude-code`

**Social preview:** Upload `assets/social-preview.jpg` in Settings → General → Social preview. A plain RGB PNG is also available at `assets/social-preview.png`. GitHub does not set either image from a file in the repository.

## Launch post

> Working on a production AI product taught me that "green" can still mean the customer outcome failed: a job was queued but never delivered, a mocked test passed while the live path broke, a source was stale, or a notification claimed success too early. I built a repeatable code audit workflow around a stricter standard: trace the real path, separate confirmed failures from guesses, reproduce what matters, and make the smallest fix.
>
> Codebase Audit is one command in a clean Git repo. It runs with Cursor, Codex, or Claude Code, applies fixes it can verify, runs available checks, and leaves a report plus a reviewable branch. There are scheduled GitHub Actions examples for Cursor and Claude that open a PR when they change code.
>
> The focused prompts are still there for billing, security, customer journeys, infrastructure, and code quality. I'd especially like feedback on false positives or places where the workflow missed an important path.
>
> https://github.com/samjhill/codebase-audit

## Short developer-community post

> I made Codebase Audit: one command for Cursor, Codex, or Claude Code to trace code paths, apply small verified fixes, run checks, and write a report on a reviewable branch. The design principle: code evidence before confident-sounding advice. Feedback and counterexamples welcome: https://github.com/samjhill/codebase-audit

## Follow-up post after a verified result

Use a real, permission-safe result. Show the question, code path, test or reproduction, smallest fix, and what the first agent answer missed. Redact secrets and customer details. Link the exact prompt and PR or commit. Avoid a victory claim based only on the agent's report.
