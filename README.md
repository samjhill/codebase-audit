# Code audits that show their work

**One command to audit a codebase and apply reviewable fixes with Cursor.** Run it once on a clean Git repository, or use the scheduled workflow to get a periodic pull request. The library also includes 25 focused prompts when you want to investigate one concern deeply.

The runner maps the application, checks relevant code and customer paths, fixes problems it can verify, runs available checks, and writes a report. It leaves high-risk or unverified changes for human review. It cannot guarantee that every bug in a codebase is found or fixed.

## Run once

Install and sign in to the [Cursor CLI](https://cursor.com/docs/cli/installation), then run this **from the root of the codebase you want to improve**:

```bash
curl -fsSL https://raw.githubusercontent.com/samjhill/useful-cursor-prompts/main/run.sh | bash
```

The command requires Git and a clean working tree. It creates a `codex/audit-*` branch, applies fixes there, and writes `.code-audit/report.md`. Review the diff and report before merging. The agent can run commands and change files; use it in a repository you trust. Cursor usage charges or plan limits may apply.

## Run periodically

Copy [the GitHub Actions example](examples/periodic-audit.yml) into your codebase as `.github/workflows/audit.yml`, add a `CURSOR_API_KEY` repository secret, and enable **Allow GitHub Actions to create and approve pull requests** under Settings → Actions → General → Workflow permissions. The workflow runs weekly on the default branch and can also be started manually. It opens a pull request only when code changes. Review each pull request before merging. Scheduled runs use Cursor API usage and GitHub Actions minutes.

## Use a focused prompt

Open the repository in Cursor, copy one prompt into Agent chat, and fill in any bracketed placeholders. For example, the [customer journey audit](customer/customer-journey-audit.md) asks for `[APPLICATION]`, `[START]`, `[KEY STEPS]`, and `[SUCCESS OUTCOME]`. Check the cited files and reproductions before acting on a finding.

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
- Report false positives and improvements through [issues](https://github.com/samjhill/useful-cursor-prompts/issues) or [a pull request](CONTRIBUTING.md).

## Cursor Automations

[Cursor Automations](https://cursor.com/docs/cloud-agent/automations) can run a focused audit on a schedule or repository event. Paste the prompt into an automation, point it at the target repository, and keep the first run read-only. Review its findings before enabling code changes or pull requests. Cloud runs can incur model usage costs.

## Why this exists

AI coding tools are good at producing plausible suggestions. They are more useful when we ask them to trace actual behavior, state uncertainty, and show how to verify a claim. This library makes those habits repeatable across a codebase. It reflects the engineering approach of [Sam Hill](https://github.com/samjhill); contributions and concrete counterexamples are welcome.

See [CONTRIBUTING.md](CONTRIBUTING.md) to propose a prompt or improve an existing one.
