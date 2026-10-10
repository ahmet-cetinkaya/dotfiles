---
name: work-planning
description: Create a decision-complete implementation plan after repository-first discovery. Use for explicit planning requests or ambiguous, multi-step, high-impact work; do not use for already-scoped implementation, active debugging, review, or verification.
---

# Work Planning

## Trigger

Use when the user requests a written plan, when product behavior or scope is unresolved, or when multi-step work needs a durable handoff. Choose **Quick Capture** for clear bounded work and **Full Brief** for cross-cutting, risky, or materially ambiguous work. Choose **Spec First** when the user asks for a spec or wants the intended behavior approved before any design: write or refine a spec under [the spec contract](references/spec-contract.md) instead of a plan.

## Non-trigger

Do not activate for an approved plan that is ready to run, a small request with known files and acceptance conditions, an active bug investigation, a read-only review, or a readiness gate.

## Workflow

1. Restate the intended outcome and inspect repository instructions, manifests, neighboring code, tests, and current working state.
2. Search narrowly for relevant entry points, call sites, conventions, ownership boundaries, and existing solutions. Ask only questions surviving [the question filter](references/question-filter.md).
3. Record decisions and assumptions. For security, authentication, persistent data, schema, migration, shared API, CI, or critical user flows, include risk, rollback, and real-surface QA.
4. Write one plan with `status: draft` to `.agents/plans/<slug>.md`; never implement while planning. Keep any unresolved user-owned decision as an explicit blocker. For a change too large to review meaningfully, recommend phased delivery only if coherent, testable phase PRs are feasible; record the user's choice or blocker using [the phased-delivery contract](references/plan-contract.md#phased-delivery-when-chosen). Otherwise keep single-PR delivery without an extra delivery-choice question. When a spec path is given, start only from a `status: approved` spec, record it as `spec:` in the plan frontmatter, and add a Traceability table mapping every `FR-###`, `SC-###`, and `PB-<n>` to tasks and evidence.
5. Validate it against [the plan contract](references/plan-contract.md) and [acceptance-criteria guidance](references/acceptance-criteria.md), then present the path for approval. Only explicit user approval changes the status to `approved`.

**Spec First** replaces steps 4–5: write or refine one spec following [the spec contract](references/spec-contract.md), run the passes in [spec quality](references/spec-quality.md), and present the path. Only explicit user approval changes a spec to `approved`; the plan comes afterwards.

A plan or spec is a handoff artifact, not authorization for destructive, remote, or shared-state actions.
