# Operational truth audit

Audit whether this application can claim success when a user, operator, or customer has not received the intended outcome. Do not modify code yet. First identify the product's primary recurring outcome from documentation and code, then trace it from input through persistence, jobs, providers, notifications, and the final user-visible state.

Investigate these failure patterns where they apply:

- A request, queue acknowledgement, or generated draft is called complete before the result is persisted, delivered, published, or otherwise visible to the user.
- Missing, stale, wrong-account, or unverified source data is treated as current and trustworthy.
- A dependency failure is converted into an empty successful result, a fixture replay, or a silent fallback.
- A test using mocks or seeded state is presented as live integration evidence; a live check skips a required stage but stays green.
- Retries, overlapping jobs, webhooks, or timeouts duplicate work or notifications, or leave partial state that cannot be resumed safely.
- Identity, role, organization, or authorship is inferred from weak signals and contaminates downstream evidence.
- Generated content makes unsupported claims, exposes internal instructions, repeats earlier work, or requires excessive customer correction.
- Alerts claim success too early, reach the wrong audience, repeat without a new state transition, or omit the next useful action.

For each confirmed finding, provide the entry-to-outcome code path, exact files and lines, a safe reproduction, user or operator impact, and the smallest practical fix. Classify evidence as code inspection, fixture/unit test, integration test, staging observation, or live provider observation. State missing credentials, telemetry, or provider access as unverified; never promote a mocked or skipped check into live acceptance. Do not access production data or send customer messages.

Return a short map of the core outcome, ranked findings, misleading green signals, coverage gaps, and the first three fixes worth making. If the primary outcome is unclear, report that explicitly rather than auditing every subsystem equally.
