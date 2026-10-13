---
name: ac:plan-review
description: Dual independent review of a plan — executability and adversarial lanes — for decision completeness, feasibility, dependencies, safety, rollback, and verifiable execution. Read-only on the plan; returns one verdict and concrete amendments.
---

# `/ac:plan-review` — Adversarial Plan Review

Challenge a plan before implementation. Surface hidden assumptions, dependency conflicts, missing owner-decisions, unsafe operations, and unverifiable tasks. Validation does not silently rewrite or approve the plan.

## Usage

```
/ac:plan-review <plan-path | pasted plan>
```

## Workflow

Activate `risk-review`. Use `explorer` to verify repository claims and `researcher` for external API, dependency, platform, or operational assumptions. Apply `secure-engineering` when risk triggers are present.

### Dual review

One round is two independent `advisor` passes dispatched together against the same plan bytes. Record `sha256sum` of the plan first; each lane receives only the plan path, that digest, and its own lane contract — never the other lane's output or your conclusions.

- **Executability lane** — step 1, plus: every referenced file, symbol, and command exists; each task can start from what the plan gives it; no tasks contradict each other; every task's QA names a tool, concrete steps, and an expected observable. Approve by default and reject only for true blockers, at most three, each specific and actionable.
- **Adversarial lane** — steps 2–5.

Each lane first re-hashes the plan and returns `INCONCLUSIVE` if the digest differs. A lane that fails or returns no verdict makes the round `INCONCLUSIVE`, never a pass.

### 1. Validate structure and status

Check that the plan names its Goal, Context, Decisions, Scope in/out, numbered tasks, dependencies, per-task acceptance criteria, QA/evidence, and final verification. A draft may contain explicit owner blockers; an approved plan may not. When `commits` is `per-task` or `per-phase`, the Commit strategy section must map every task to one commit with the files it stages and a proposed message.

When the plan carries `spec:`, also run a coverage pass against that spec: the spec must be `approved` with no open `[NEEDS CLARIFICATION]` marker; every `FR-###`, `SC-###`, and `PB-<n>` must appear in the Traceability table with a task and an evidence source; every task must trace to a criterion or state why it exists; and no task may contradict a requirement or a preserved behavior. Report uncovered criteria and unrequested tasks as blocking findings. Then scan spec and plan together for: near-duplicate requirements; vague adjectives or placeholders without an observable; requirements missing an object or a measurable outcome; success criteria that need buildable work (performance, security, availability) but have no task; terminology drift and entities named in one artifact but absent from another, including the design artifacts; data-model rules or contract operations that trace to no requirement; conflicting requirements; and task order that contradicts dependencies. A finding blocks only under the blocking bar in step 6.

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

Merge the two lanes: the round verdict is the worse of the two, and `VALID` requires both lanes to return `VALID`. Return concrete amendments at the owning task/decision, preserving intentional scope. Do not inflate confidence into a pseudo-precise percentage.

A finding is blocking only when it cites concrete evidence for one of: a conflict with an explicit requirement or accepted decision, an existing failing regression, a reproducible broken flow, a concrete security, data-loss, or compatibility risk, or a conflict with an external API, provider, or release contract. Everything else — speculative hardening, durability, or edge cases the accepted scope never required — is a non-blocking improvement, and a plan whose only findings are non-blocking is `VALID`. Fixes take the smallest edit that resolves the cited blocker and never grow scope.

A re-review of an amended plan runs both lanes fresh against the new digest and checks only the earlier blocking findings, regressions the fixes introduced, and new findings that meet the blocking bar; it does not rediscover the plan. After five rounds without `VALID`, stop and ask the user to continue, accept, or adjust.

For a plan file, record each lane's verdict, the round, and the digest in the plan's run state (`state.json` review receipts and a `review` ledger event under `.agents/state/<slug>/`). Any later change to the plan invalidates both receipts; before reporting `VALID`, re-hash the plan and require it to match the reviewed digest. A pasted plan gets the verdict without receipts.

## Output

```markdown
# Plan Review Report

## Verdict

VALID | VALID_WITH_CHANGES | INVALID | INCONCLUSIVE

Confidence: HIGH | MEDIUM | LOW

## Lanes

Executability: <verdict> · Adversarial: <verdict> · Round <n> · Plan sha256 <digest>

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
- `VALID_WITH_CHANGES` → apply the amendments via `/ac:plan <request>`, then re-review if the changes were material
- `INVALID` → `/ac:plan <request>` to redesign from the blocking findings
- The gap is in the spec, not the plan → `/ac:spec <spec-path>` to refine it first
- `INCONCLUSIVE` → name the missing evidence and stop

Name exactly one recommendation. Never approve or execute the plan yourself.

## Boundaries

- Read-only on the plan: do not implement, edit the plan, approve it, or change its status. The only writes are the review receipts in the run state.
- Do not invent blockers or require ceremony unrelated to actual risk.
- If the user wants amendments applied, create a separate revised draft or hand back to `/ac:plan`.
