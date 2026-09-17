# Codebase Audit

**Code audits that show their work.** One command runs an evidence-first audit with Cursor, Codex, or Claude Code, applies reviewable fixes, and writes a report. The library also includes 25 focused prompts for investigating one concern deeply.

The runner maps the application, checks relevant code and customer paths, fixes problems it can verify, runs available checks, and writes a report. It leaves high-risk or unverified changes for human review. It cannot guarantee that every bug in a codebase is found or fixed.

## Run once

Install and sign in to the [Cursor CLI](https://cursor.com/docs/cli/installation), [Codex CLI](https://learn.chatgpt.com/docs/codex/cli), or [Claude Code CLI](https://code.claude.com/docs/en/setup), then run this **from the root of the codebase you want to improve**:

```bash
curl -fsSL https://raw.githubusercontent.com/samjhill/codebase-audit/main/run.sh | bash
```

The command requires Git and a clean working tree. It creates an `audit/*` branch, applies fixes there, and writes `.code-audit/report.md`. If multiple CLIs are installed, it chooses Cursor, then Codex, then Claude. To choose explicitly, append `-s -- --agent claude` (or `codex` or `cursor`) to the command. Review the diff and report before merging. The agent can run commands and change files; usage charges or plan limits may apply. Claude runs noninteractively with its [automatic permission mode](https://code.claude.com/docs/en/headless); its classifier may deny an action, which should be recorded in the report.

For Claude Code specifically, use:

```bash
curl -fsSL https://raw.githubusercontent.com/samjhill/codebase-audit/main/run.sh | bash -s -- --agent claude
```

## Run periodically

Copy either the [Cursor](examples/periodic-audit.yml) or [Claude](examples/periodic-audit-claude.yml) GitHub Actions example into your codebase as `.github/workflows/audit.yml`. Add a `CURSOR_API_KEY` secret for Cursor or an `ANTHROPIC_API_KEY` secret for Claude. Enable **Allow GitHub Actions to create and approve pull requests** under Settings → Actions → General → Workflow permissions. Each example runs weekly on the default branch, supports manual runs, and opens a pull request only when code changes. Review each pull request before merging. Scheduled runs use agent API usage and GitHub Actions minutes.

## Use a focused prompt

Open the repository in Cursor, Codex, or Claude Code, copy one prompt into its chat, and fill in any bracketed placeholders. For example, the [customer journey audit](customer/customer-journey-audit.md) asks for `[APPLICATION]`, `[START]`, `[KEY STEPS]`, and `[SUCCESS OUTCOME]`. Check the cited files and reproductions before acting on a finding.

For a quick technical pass, try [dead code](code/dead-code.md). For a sensitive workflow, start with the read-only [billing lifecycle](code/backend/billing-lifecycle-audit.md) or [security](security/security-audit.md) audit.

These are prompts, not scanners. Results depend on repository access, context, and model behavior. A plausible finding is not a verified bug. A clean security audit is not a security certification.

## What a useful finding looks like

This is an **illustrative format**, not a finding from a real repository:

> - **Finding:** A duplicate payment webhook can grant the same credit twice.
> - **Evidence:** `src/billing/webhook.ts:84` writes a credit without checking the provider event ID.
> - **Reproduce:** Deliver the same sandbox event twice and compare the account balance.
> - **Impact:** A customer may receive more credit than they purchased.
> - **Smallest fix:** Persist processed event IDs and make the credit write idempotent.
> - **Confidence:** Requires a sandbox reproduction; the code path alone does not prove provider retry behavior.

The goal is a decision you can verify, not a long list of generic advice. Read the [design principles](DESIGN.md) for the reasoning behind the prompts.

## Pick an audit

| If you need to… | Start here |
| --- | --- |
| Find a broken customer flow | [Customer journey](customer/customer-journey-audit.md) |
| Catch misleading success signals | [Operational truth](code/operational-truth.md) |
| Check whether onboarding is truly ready | [Onboarding readiness](customer/onboarding-readiness-audit.md) |
| Trace subscription state and payment failures | [Billing lifecycle](code/backend/billing-lifecycle-audit.md) |
| Investigate security exposure | [Evidence-based security audit](security/security-audit.md) |
| Find expensive or fragile infrastructure | [Infrastructure](code/infrastructure.md) |
| Remove unused code | [Dead code](code/dead-code.md) |
| Reduce CI time or cost | [GitHub Actions CI cost](code/github-actions-ci-cost.md) |

### All prompts

**Investigate first:** [customer journey](customer/customer-journey-audit.md) · [onboarding readiness](customer/onboarding-readiness-audit.md) · [billing lifecycle](code/backend/billing-lifecycle-audit.md) · [security audit](security/security-audit.md) · [infrastructure](code/infrastructure.md)

**Cross-cutting code:** [operational truth](code/operational-truth.md) · [boundaries](code/boundaries.md) · [dead code](code/dead-code.md) · [dependencies](code/dependencies.md) · [naming](code/naming-clarity.md) · [type safety](code/type-safety.md) · [complexity](code/complexity.md) · [state ownership](code/state-ownership.md) · [edge cases](code/edge-case.md) · [test suite](code/test-suite.md) · [performance](code/performance.md) · [engineer onboarding](code/engineer-onboarding.md) · [CI cost](code/github-actions-ci-cost.md)

**Frontend:** [code cleanup](code/frontend/frontend-code-cleanup.md) · [logic cleanup](code/frontend/frontend-logic-cleanup.md) · [accessibility](code/frontend/a11y.md)

**Backend:** [code cleanup](code/backend/backend-code-cleanup.md) · [logic cleanup](code/backend/backend-logic-cleanup.md) · [logging](code/backend/logging.md)

The older [code security pass](code/security-audit.md) is a short fix-oriented checklist. Use the [evidence-based security audit](security/security-audit.md) when you need a ranked, read-only investigation.

## How to use the results

- Run **one prompt at a time**. Narrow the scope to a feature or service if the repository is large.
- Give the agent relevant product docs, fixtures, or incident details when you have them. Remove customer data and secrets first.
- Treat file references and line numbers as leads to inspect. Reproduce high-impact findings with tests, mocks, or sandbox data.
- For prompts that allow edits, review the plan and diff. Run the repository's checks and verify user-visible behavior before merging.
- Report false positives and improvements through [issues](https://github.com/samjhill/codebase-audit/issues) or [a pull request](CONTRIBUTING.md).

## Other automation options

[Cursor Automations](https://cursor.com/docs/cloud-agent/automations) can run a focused audit on a schedule or repository event. Paste the prompt into an automation, point it at the target repository, and keep the first run read-only. Review its findings before enabling code changes or pull requests. Cloud runs can incur model usage costs.

## Why this exists

AI coding tools are good at producing plausible suggestions. They are more useful when we ask them to trace actual behavior, state uncertainty, and show how to verify a claim. This library makes those habits repeatable across a codebase. It reflects the engineering approach of [Sam Hill](https://github.com/samjhill); contributions and concrete counterexamples are welcome.

See [CONTRIBUTING.md](CONTRIBUTING.md) to propose a prompt or improve an existing one.
