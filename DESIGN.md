# How these audits are designed

The job of an audit prompt is to help a human decide what to inspect or change. A long answer is not evidence of a good audit.

## Principles

1. **Start with a real path.** Ask the agent to trace a request, event, user action, or deployment from entry point to outcome. This makes findings specific to the repository.
2. **Separate observation from inference.** A code path may establish a defect; other claims need a test, production telemetry, provider settings, or a human check. Label that difference.
3. **Make findings reproducible.** Request exact files, a test or sandbox reproduction, impact, and the smallest fix. Reject a checklist item with no demonstrated path to failure.
4. **Investigate before editing when the stakes are high.** Billing, security, customer journeys, and infrastructure start read-only. A suggested fix becomes a separate, reviewable step.
5. **Keep the change small.** A focused audit should not authorize a broad rewrite. Preserve behavior where appropriate and explain any intended behavior change.
6. **Account for what the repo cannot show.** Deployed configuration, logs, billing data, and user experience may be outside the agent's view. Unknowns belong in the output.

## A prompt's output contract

For each material finding, request:

| Field | Question it answers |
| --- | --- |
| Finding | What is wrong or risky? |
| Evidence | Which code path or configuration supports the claim? |
| Reproduction | How can a person verify it safely? |
| Impact | Who is affected and how? |
| Smallest fix | What change would address the demonstrated problem? |
| Confidence | What is confirmed, inferred, or still unknown? |

An audit can return no confirmed findings. That is better than manufacturing issues to fill a list.

## Failure patterns that shaped the runner

Production systems often report success at the wrong boundary. A job can be queued but never finish; a draft can be generated but not useful or published; a notification can say “done” before the provider confirms delivery. The runner asks for the final persisted or user-visible outcome.

Tests can also overstate confidence. Fixture replay, seeded state, skipped stages, and mocked providers are valuable for regression checks, but each must be labeled accurately. A green fixture test does not establish a working live integration.

Evidence pipelines can quietly degrade through stale source data, wrong-person attribution, duplicate work, or unsupported generated claims. The runner asks agents to trace those inputs into downstream decisions and customer output. It also asks for the smallest fix to the actual state or data problem before expanding integrations or redesigning the interface.

## Reviewing a result

Open cited files and follow the path yourself. Check whether the agent missed guards, tests, runtime configuration, or another owner of the state. For security and billing, verify with a qualified reviewer and safe test data before making consequential changes. If you improve a prompt after finding a false positive, describe the failure mode in the pull request so others can learn from it.
