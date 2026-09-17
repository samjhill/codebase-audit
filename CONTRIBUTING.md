# Contributing

Concrete failures and counterexamples make this library better. Open an issue before adding a broad new category; small fixes to existing prompts can go straight to a pull request.

## Propose a prompt

Include:

1. The decision the audit helps a developer make.
2. The repository evidence the agent should inspect.
3. The finding format: code path, safe reproduction, impact, smallest fix, and uncertainty.
4. Clear scope and whether the prompt is read-only or may edit code.
5. A redacted example of a useful result or a false positive the prompt prevents, if available.

Keep prompts focused. Avoid instructions that require live production changes, expose secrets, claim certainty from static code alone, or force a predetermined number of findings. Prefer existing project conventions over new frameworks.

## Pull request checklist

- Explain the problem with the current wording.
- Link the affected prompt and describe the proposed change.
- Verify Markdown links and placeholders.
- If you ran the prompt, summarize what improved and where it still struggled. Do not include private code or customer data.

Prompt behavior varies by model and repository. A single run is useful feedback, not a guarantee of performance.
