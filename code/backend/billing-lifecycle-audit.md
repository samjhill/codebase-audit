# Billing lifecycle audit

Audit [APPLICATION]'s subscription and billing lifecycle using actual code paths and provider configuration available in this repository. Trace signup or trial, payment, renewal, failed payment, plan change, cancellation, and reactivation, adapting the sequence to supported features. Do not modify code yet. Do not trigger real charges or change production subscriptions.

Check whether provider events reliably update account state, including duplicate, delayed, missing, and out-of-order webhooks. Verify that access and limits match paid entitlements, cancellation stops future charges as intended, and payment failures and receipts reach the user and responsible support owner where applicable. Inspect how each state appears in the UI.

For each finding, provide the exact code path, a concrete reproduction or test using mocks or sandbox data, financial or user impact, and smallest practical fix. Separate confirmed failures from cases requiring provider or production data. Do not expose payment details or secrets.

Return ranked findings, a map of billing states and transitions, and the minimum tests and alerts to detect payment or entitlement drift. Prioritize lost revenue, unintended charges, and users who silently lose access.
