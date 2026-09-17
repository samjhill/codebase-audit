# Launch kit

Publish after the one-command runner is on `main` and has been tested in a disposable repository. The posts below are drafts to adapt in Sam's own voice. Do not claim a real bug or result until one has been reproduced and reviewed.

## GitHub repository settings

**Description:** One command to audit a codebase with Cursor, apply reviewable fixes, and run it periodically.

**Topics:** `cursor`, `cursor-ai`, `ai-coding`, `code-audit`, `developer-tools`, `automation`, `code-quality`

**Social preview:** Upload `assets/social-preview.png` in Settings → General → Social preview. GitHub does not set this image from a file in the repository.

## Launch post

> Working on a production AI product taught me that "green" can still mean the customer outcome failed: a job was queued but never delivered, a mocked test passed while the live path broke, a source was stale, or a notification claimed success too early. I built a repeatable code audit workflow around a stricter standard: trace the real path, separate confirmed failures from guesses, reproduce what matters, and make the smallest fix.
>
> The new runner is one command in a clean Git repo. It asks Cursor to audit the application, apply fixes it can verify, run available checks, and leave a report plus a reviewable branch. There's also a scheduled GitHub Actions example that opens a PR when it changes code.
>
> The focused prompts are still there for billing, security, customer journeys, infrastructure, and code quality. I'd especially like feedback on false positives or places where the workflow missed an important path.
>
> https://github.com/samjhill/useful-cursor-prompts

## Short developer-community post

> I made a one-command Cursor audit runner and a library of focused prompts. It traces code paths, applies small verified fixes, runs checks, and writes a report on a branch for review. Scheduled runs can open a PR. The design principle: code evidence before confident-sounding advice. Feedback and counterexamples welcome: https://github.com/samjhill/useful-cursor-prompts

## Follow-up post after a verified result

Use a real, permission-safe result. Show the question, code path, test or reproduction, smallest fix, and what the first agent answer missed. Redact secrets and customer details. Link the exact prompt and PR or commit. Avoid a victory claim based only on the agent's report.
