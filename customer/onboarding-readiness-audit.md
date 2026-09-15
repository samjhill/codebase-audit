# Onboarding and readiness audit

Audit [APPLICATION]'s onboarding and account configuration. Trace a new user from signup through [CONNECTIONS], [PERMISSIONS], [DATA IMPORT OR INVENTORY], and the first successful [CORE ACTION]. Identify the actual path from code and docs if these steps differ. Do not modify code yet.

Determine what the application considers ready at each step and whether that status reflects usable, current data. Look for missing or stale inputs, expired permissions, wrong-account or wrong-resource associations, partial imports, and failures that let the core action proceed with misleading inputs. Check what the user sees and whether they can resolve each issue. Use [ANONYMIZED INCIDENT OR FIXTURE] if provided.

For every finding, provide the exact code path, a concrete reproduction or test, user impact, and the smallest practical fix. Separate confirmed failures from cases requiring production data. Prioritize onboarding that appears successful while the subsequent experience is degraded.

Return ranked findings, a readiness checklist based on verifiable state, and tests that keep it accurate. Keep recommendations within the existing workflow.
