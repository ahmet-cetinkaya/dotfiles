---
name: ac:plan-validate
description: Red-team a plan for decision completeness, feasibility, dependencies, safety, rollback, and verifiable execution. Read-only; returns a structured verdict and concrete amendments.
---

# `/ac:plan-validate` — Adversarial Plan Review

Challenge a plan before implementation. Surface hidden assumptions, dependency conflicts, missing owner-decisions, unsafe operations, and unverifiable tasks. Validation does not silently rewrite or approve the plan.

## Usage

```
/ac:plan-validate <plan-path | pasted plan>
```

## Workflow

Activate `risk-review` and route independent synthesis to `advisor`. Use `explorer` to verify repository claims and `researcher` for external API, dependency, platform, or operational assumptions. Apply `secure-engineering` when risk triggers are present.

### 1. Validate structure and status

Check that the plan names its Goal, Context, Decisions, Scope in/out, numbered tasks, dependencies, per-task acceptance criteria, QA/evidence, and final verification. A draft may contain explicit owner blockers; an approved plan may not.

When the plan carries `spec:`, also run a coverage pass against that spec: the spec must be `approved` with no open `[NEEDS CLARIFICATION]` marker; every `FR-###`, `SC-###`, and `PB-<n>` must appear in the Traceability table with a task and an evidence source; every task must trace to a criterion or state why it exists; and no task may contradict a requirement or a preserved behavior. Report uncovered criteria and unrequested tasks as blocking findings.

### 2. Bust assumptions

For every material assumption ask:

- What evidence supports it?
- What breaks if it is false?
- Is it a reversible implementation default or an owner-decision?
- Does current repository state or authoritative documentation contradict it?

### 3. Trace dependencies and write ownership

Check for circular/missing dependencies, tasks whose outputs are consumed before they exist, unsafe parallel write sets, and shared files such as manifests, lockfiles, generated outputs, settings, migrations, or plans that need exclusive ownership.

### 4. Attack feasibility and failure paths

Evaluate resource and compatibility constraints, partial failure, retries/idempotency, concurrency, data integrity, migration/rollback, security and abuse paths, shared/public API impact, observability, and operational recovery. Verify important claims against code or authoritative sources rather than grading prose alone.

### 5. Challenge verification

Every task needs a binary observable and a realistic evidence source. Reject tautological tests, vague “works/secure/robust” criteria, dry runs standing in for required real execution, and final verification that cannot detect the failure it claims to cover.

### 6. Produce amendments and verdict

Return concrete amendments at the owning task/decision, preserving intentional scope. Do not inflate confidence into a pseudo-precise percentage.

## Output

```markdown
# Plan Validation Report

## Verdict
VALID | VALID_WITH_CHANGES | INVALID | INCONCLUSIVE
Confidence: HIGH | MEDIUM | LOW

## Blocking Findings
## Spec Coverage (when a spec is linked)
## Non-Blocking Improvements
## Assumptions and Evidence
## Dependency / Write-Set Analysis
## Risk, Rollback, and Observability Gaps
## Verification Gaps
## Required Amendments
## Residual Risks
```

## Next Step

Close the turn by mapping the verdict to one command:

- `VALID` → approve the plan, then `/ac:run <plan-path>`
- `VALID_WITH_CHANGES` → apply the amendments via `/ac:plan <request>`, then re-validate if the changes were material
- `INVALID` → `/ac:plan <request>` to redesign from the blocking findings
- The gap is in the spec, not the plan → `/ac:spec <spec-path>` to refine it first
- `INCONCLUSIVE` → name the missing evidence and stop

Name exactly one recommendation. Never approve or execute the plan yourself.

## Boundaries

- Read-only: do not implement, edit the plan, approve it, or change its status.
- Do not invent blockers or require ceremony unrelated to actual risk.
- If the user wants amendments applied, create a separate revised draft or hand back to `/ac:plan`.
