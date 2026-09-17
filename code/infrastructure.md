You are conducting a comprehensive infrastructure, CI/CD, processing, cost, resilience, and performance audit of this application.

## Objective

Identify concrete improvements that will:

1. Reduce recurring infrastructure and third-party costs.
2. Improve reliability and graceful failure handling.
3. Improve application and background-processing performance.
4. Make deployments faster, safer, and easier to roll back.
5. Reduce operational complexity and maintenance burden.
6. Improve visibility into failures, bottlenecks, capacity, and spend.

Treat the repository and deployed configuration as the source of truth. Do not assume the architecture matches documentation. Trace how the system actually builds, deploys, runs, processes work, stores data, communicates with external services, and recovers from failure.

## Scope

Inspect all relevant areas, including:

* Infrastructure-as-code: Terraform, Serverless, CloudFormation, CDK, Docker, and deployment configuration
* CI/CD pipelines and GitHub Actions
* AWS resources and their configuration
* API request paths and application startup
* Lambda functions, containers, workers, and scheduled jobs
* Queues, event buses, webhooks, retries, and dead-letter handling
* AI/model calls and other usage-priced APIs
* Content-generation and analysis pipelines
* Batch and asynchronous processing
* PostgreSQL, DynamoDB, Redis, search, and other persistence layers
* Object storage, file processing, and data-retention policies
* Network calls and external integrations
* Caching and deduplication
* Logging, metrics, tracing, dashboards, and alerts
* Environment and secrets management
* Deployment safety, rollback, recovery, and disaster preparedness
* Development, staging, preview, and production environment duplication
* Orphaned, idle, oversized, or unnecessarily duplicated resources

Follow repository-level instruction files such as `AGENTS.md`, `CLAUDE.md`, or equivalent.

## Phase 1: Map the real system

Before recommending changes, produce an evidence-backed architecture inventory showing:

* Every deployable service, worker, function, and scheduled task
* How each component is triggered
* Its upstream inputs and downstream dependencies
* Where synchronous work occurs
* Where asynchronous work occurs
* Databases, tables, buckets, queues, caches, and external services used
* Which resources are shared versus environment-specific
* CI/CD workflows and what each one builds, tests, and deploys
* Known retry, timeout, concurrency, batching, and rate-limit behavior
* The most important end-to-end processing paths

Pay particular attention to the primary customer workflows. Trace each workflow from initial request or event through processing, persistence, external API/model usage, and final user-visible result.

Flag infrastructure that appears to be unused, duplicated, obsolete, or inconsistent with the running application—but do not delete anything based only on static-reference searches.

## Phase 2: Establish a baseline

Use repository evidence, configuration, tests, logs, metrics, or available cloud billing/usage data to establish as much of the following as possible:

* Major recurring cost centers
* Usage-priced operations and their approximate unit economics
* Compute duration, memory allocation, concurrency, and utilization
* Database query volume and likely expensive queries
* Queue depth, processing latency, failure rate, and retry volume
* Model/API calls per customer workflow
* Duplicate or avoidable processing
* Cache hit/miss behavior, where observable
* Build and deployment duration
* Test duration and repeated CI work
* Artifact and dependency sizes
* Cold-start exposure
* Storage growth and retention
* Log-ingestion and retention costs
* Third-party subscription or per-request costs visible in configuration

Clearly distinguish:

* Measured facts
* Facts inferred from code or configuration
* Unknowns requiring production telemetry or billing access

Do not invent savings numbers. If exact billing data is unavailable, provide a bounded estimate only when the assumptions are explicit.

## Phase 3: Audit each area

### Cost efficiency

Look for:

* Oversized memory, CPU, database, or container allocations
* Always-on resources that could scale to zero or run on demand
* Excessive Lambda invocations or duration
* Unnecessary environment duplication
* Redundant model/API requests
* Processing repeated for unchanged inputs
* Missing caching, batching, deduplication, or incremental processing
* Excessive logging or overly long retention
* Stale artifacts, snapshots, database records, or object versions
* Missing object-storage lifecycle policies
* Avoidable NAT, cross-region, or data-transfer costs
* Expensive polling that could be event-driven
* Inefficient scheduled jobs
* Excessive dependency or container image size
* Unused resources that may still incur cost
* Resources whose architectural complexity costs more to operate than their value justifies

For AI workloads, specifically inspect:

* Model choice relative to task difficulty
* Token usage and oversized context
* Repeated retrieval or prompt construction
* Duplicate generations
* Retry behavior that can multiply spend
* Opportunities for bounded caching or reuse
* Whether deterministic preprocessing can safely reduce model workload
* Whether smaller or cheaper models can handle well-bounded tasks without harming customer-visible quality

Do not recommend cost reductions that materially weaken output quality, accuracy, or trustworthiness.

### CI/CD

Inspect for:

* Workflows triggered more often than necessary
* Duplicate dependency installation, compilation, linting, or testing
* Missing dependency and build caching
* Jobs that should run in parallel
* Jobs that should be conditional on changed paths
* Unsafe deployment ordering
* Missing deployment concurrency controls
* Race conditions between workflows
* Mutable or unpinned dependencies and actions
* Overprivileged workflow permissions
* Secrets exposed too broadly
* Missing environment protection
* Missing smoke tests and post-deployment verification
* Lack of canary, staged, or progressive rollout where warranted
* Inadequate rollback support
* Database migrations that can break old or new application versions
* Long-lived branches or preview environments leaking resources
* CI checks that are noisy, flaky, or do not protect meaningful invariants

Determine whether deployments are reproducible and whether a previous known-good version can be restored quickly.

### Processing architecture

Inspect all background and long-running workflows for:

* Work performed synchronously that should be asynchronous
* Long chains with no checkpoint or restart capability
* Missing idempotency
* Duplicate event delivery
* Unbounded fan-out or concurrency
* Queue starvation or head-of-line blocking
* Poor batch sizing
* Timeout mismatches
* Retry storms
* Poison messages
* Missing dead-letter queues or redrive procedures
* Partial completion that leaves inconsistent state
* External calls made inside database transactions
* Sequential work that can safely be parallelized
* Parallel work that risks exhausting dependencies
* Reprocessing of unchanged data
* Missing backpressure or admission control
* Cron jobs that overlap with themselves
* Jobs that silently fail after acknowledging work

Prioritize correctness and recoverability. “Make it asynchronous” is not sufficient unless ownership, state transitions, idempotency, retries, and user-visible status are addressed.

### Performance

Find evidence of:

* Slow request paths
* N+1 queries
* Full-table scans
* Missing or ineffective indexes
* Repeated serialization or large payload transfer
* Excessive network round trips
* Sequential independent calls
* Expensive work performed on every request
* Cold-start contributors
* Large bundles or container images
* Ineffective connection pooling
* Missing pagination or unbounded result sets
* Over-fetching from databases and external APIs
* Poorly chosen timeouts
* Slow or redundant build steps

Optimize customer-visible latency first, then throughput and infrastructure utilization. Note when a performance change could raise cost or reduce resilience.

### Resilience and operability

Inspect for:

* Single points of failure
* Missing health checks
* Missing timeouts, retry limits, jitter, or circuit breakers
* Unsafe retry behavior for non-idempotent operations
* Failure amplification across services
* Lack of graceful degradation
* Unclear state transitions
* Insufficient backups or untested restoration
* Missing rollback or disaster-recovery procedures
* Data loss windows
* Region or availability-zone assumptions
* Dependency outages that can block unrelated workflows
* Lack of rate-limit handling
* Alerts without actionable context
* Important failures that generate no alert
* Alert noise that hides real incidents
* Sensitive data or customer content in logs
* Runbooks that are missing or inconsistent with the code

For each critical workflow, explain what happens if every major dependency times out, rejects requests, returns malformed data, or remains unavailable.

### Simplification

Look for infrastructure whose complexity is not justified by current product scale:

* Multiple systems doing overlapping work
* Premature abstractions
* Legacy deployment paths
* Parallel implementations
* Infrastructure retained for abandoned features
* Unnecessary environment-specific divergence
* Hand-built orchestration that a simpler existing primitive could replace
* Too many independently deployed units for the team’s operational capacity

Prefer deleting or consolidating unnecessary machinery when the evidence supports it. Do not propose major migrations merely because another technology is fashionable.

## Phase 4: Produce prioritized findings

Create a report with these sections:

### 1. Executive summary

Summarize:

* The current architecture
* The five highest-value improvements
* The most serious resilience risk
* The largest credible cost-saving opportunity
* The biggest performance bottleneck
* The highest-value CI/CD improvement
* Any issue that warrants immediate action

### 2. Architecture and workflow map

Document the real components and primary processing paths, citing relevant files, symbols, workflows, and resource definitions.

### 3. Findings table

For every finding, include:

| Field            | Required content                                                                             |
| ---------------- | -------------------------------------------------------------------------------------------- |
| Finding          | Concise description                                                                          |
| Category         | Cost, CI/CD, processing, performance, resilience, observability, security, or simplification |
| Evidence         | Exact files, symbols, configuration, metrics, or logs                                        |
| Current behavior | What the system does today                                                                   |
| Impact           | Customer, engineering, operational, and financial consequences                               |
| Recommendation   | Specific proposed change                                                                     |
| Expected benefit | Measurable or explicitly bounded benefit                                                     |
| Risk             | What could go wrong                                                                          |
| Effort           | S, M, L, or XL                                                                               |
| Confidence       | High, medium, or low                                                                         |
| Validation       | How to prove the change worked                                                               |
| Rollback         | How to undo it safely                                                                        |
| Priority         | P0, P1, P2, or P3                                                                            |

Priority definitions:

* **P0:** Active risk of data loss, security failure, major outage, runaway spend, or unrecoverable deployment
* **P1:** High-value change appropriate for the next 30 days
* **P2:** Valuable after measurement, prerequisites, or P1 work
* **P3:** Low urgency, speculative, or limited return

### 4. Cost model

Document the primary cost drivers and, where possible:

* Current estimated cost
* Cost per job, customer, generated artifact, or workflow
* Projected cost after the recommended change
* Savings range
* Assumptions
* Metrics needed to verify the estimate

### 5. Resilience review

For each critical workflow, describe:

* Failure modes
* Existing protections
* Missing protections
* Recovery behavior
* Data-consistency risk
* Recommended alerts
* Recommended runbook or redrive process

### 6. CI/CD review

Describe the existing deployment flow, major weaknesses, and a proposed target flow. Include concrete workflow-level changes.

### 7. 30-day execution plan

Organize recommended work into:

* Immediate safety fixes
* Week 1: measurement and low-risk quick wins
* Week 2: CI/CD and deployment safety
* Week 3: processing, performance, and cost improvements
* Week 4: resilience validation, cleanup, and documentation

Respect dependencies between tasks. Avoid scheduling speculative optimizations before the necessary metrics exist.

## Phase 5: Create a GitHub epic

Create one GitHub epic titled:

**Infrastructure Efficiency, Resilience & Performance**

The epic should contain:

* Problem statement
* Current-state summary
* Goals
* Explicit non-goals
* Baseline metrics
* Proposed architecture changes
* Ordered implementation phases
* Individual child issues or task checklists
* Acceptance criteria
* Required tests
* Monitoring and success metrics
* Rollout strategy
* Rollback strategy
* Risks and open questions

Each child issue must be independently reviewable and include:

* Problem and supporting evidence
* Exact scope
* Proposed implementation
* Acceptance criteria
* Tests
* Telemetry
* Deployment plan
* Rollback plan
* Dependencies

Use repository conventions for labels, milestones, and issue structure. If direct GitHub access is unavailable, generate the complete epic and child-issue Markdown in the repository.

## Implementation rules

Do not begin with a sweeping rewrite.

After completing the audit and epic:

1. Identify safe quick wins that have strong evidence, low blast radius, and clear validation.
2. Present the proposed changes before applying anything with production or architectural risk.
3. You may implement narrowly scoped, reversible repository improvements such as CI caching, safe workflow deduplication, missing timeout configuration, or instrumentation when their correctness is clear.
4. Do not delete cloud resources, alter production data, change billing plans, rotate secrets, or deploy to production.
5. Do not change customer-visible behavior solely to save money.
6. Preserve existing correctness, security, and data-integrity guarantees.
7. Add or update tests for every behavioral change.
8. Make small, logically separated commits if commits are requested or permitted.
9. Run the relevant test, lint, type-check, and infrastructure validation commands after changes.
10. Report anything that cannot be verified locally.

## Quality bar

Avoid generic advice such as “add caching,” “use autoscaling,” or “improve monitoring.” Every recommendation must identify:

* The exact observed problem
* The repository evidence
* The specific change
* Why it fits this system
* The metric it should improve
* The tradeoffs it introduces
* How it will be validated
* How it will be rolled back

Be skeptical of optimization for its own sake. Favor the smallest changes that produce meaningful savings, resilience, or customer-visible performance gains.
