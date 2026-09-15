# Customer journey audit

Audit [APPLICATION]'s core customer journey using its code, tests, and available fixtures. First identify the intended workflow from product documentation and code, then trace a realistic user end to end: [START] → [KEY STEPS] → [SUCCESS OUTCOME]. Do not modify code yet.

At each step, describe what the user sees, how state is saved, what can fail silently, and how the system detects and recovers. Investigate known incidents if supplied: [ANONYMIZED INCIDENTS OR FIXTURES]. Check whether notifications or support signals reach an accountable owner where applicable.

Prioritize reproducible, user-visible failures. For each finding, include the exact code path, a concrete reproduction or test, user impact, and smallest practical fix. Separate confirmed failures from risks requiring production data or manual verification. Avoid speculative bug lists.

Return the five highest-impact findings, regression checks, a minimal set of per-user success/failure signals, and a fix sequence that strengthens the current workflow. Do not propose new features unless they directly resolve a demonstrated failure.
