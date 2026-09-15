# Security audit

Audit this application for security vulnerabilities. Read the repository and trace how untrusted input moves through routes, background jobs, integrations, storage, and deployment configuration. Do not modify code yet. Do not run destructive or intrusive tests against production.

Focus on authentication and sessions, authorization and cross-tenant access (if multi-tenant), exposed secrets, injection, uploads, SSRF, webhooks, payment flows (if present), rate limiting, CORS/CSRF, dependencies, sensitive logging, and insecure defaults. Include frontend issues where they create real exposure. Prioritize access to another user's data and unauthenticated attack paths.

For each finding, provide severity, exploit prerequisites, exact files and lines, a concrete entry-point-to-impact path, code evidence, the smallest practical fix, and a regression test. Distinguish confirmed vulnerabilities from plausible risks requiring testing. Do not report checklist items without a code-backed path. Do not print secrets or authentication codes.

End with a ranked remediation plan and areas this repository cannot verify.
