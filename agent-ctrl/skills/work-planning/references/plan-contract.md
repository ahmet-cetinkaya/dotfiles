# Plan Contract

A durable plan under `.agents/plans/<slug>.md` contains frontmatter followed by the plan body:

```yaml
---
status: draft
spec: # optional: specs/changes/<NNNN>-<slug>/SPEC.md this plan implements
---
```

Valid lifecycle values are `draft`, `approved`, `in_progress`, `blocked`, and `completed`. The planner writes `draft`. Only explicit user approval changes it to `approved`; approval does not authorize risky operations described inside the plan. The executor changes `approved → in_progress` before the first implementation task, `in_progress → blocked` when progress cannot continue, `blocked → in_progress` only after the blocker is resolved, and `in_progress → completed` only after final verification passes. An interrupted `in_progress` plan is resumed from its task states and evidence; it is not restarted blindly.

The plan body contains:

1. **Goal** — outcome and reason.
2. **Context** — relevant paths, symbols, current behavior, conventions, and constraints.
3. **Decisions** — resolved alternatives, assumptions, and user-owned choices.
4. **Scope** — explicit in-scope and out-of-scope boundaries.
5. **Tasks** — numbered changes with exact files or discovery targets.
6. **Dependencies** — predecessor tasks and safe parallel groups.
7. **Per-task acceptance criteria** — observable proof for each task.
8. **QA and evidence** — project-defined checks, real-surface scenarios, risk gates, rollback evidence, and expected observables.
9. **Final verification** — checks over the complete delivered state.
10. **Traceability** — required when `spec:` is set: a table with one row per `FR-###`, `SC-###`, and `PB-<n>` from the spec, naming the task(s) that satisfy it and the evidence source that proves it. A criterion with no task is a planning gap; a task with no criterion is unrequested work and needs a stated reason.

A plan derived from a spec starts only from a spec with `status: approved` and no `[NEEDS CLARIFICATION]` marker; the plan's Decisions section records the Constitution Check — whether the design honors the project's instruction files (`AGENTS.md`, `CLAUDE.md`, or equivalent) and, for each conflict, the justification or the owner-decision it raises.

Task status is exactly `pending`, `in_progress`, `blocked`, or `completed`. Keep only genuinely executing work `in_progress`; mark completion only after its acceptance evidence passes. An unresolved user-owned decision keeps the plan `draft` and must appear under Decisions as a blocker.

## Phased delivery (when chosen)

Optional; use it only when the user chose it after the dual condition held: the total PR is not meaningfully reviewable given scope, coupling, risk, or context, and coherent phases exist that can each be scoped, tested, and reviewed as a PR. No fixed file or line thresholds apply. The plan stays one durable draft; phases group the existing numbered task IDs and add no separate plans, lifecycle states, or frontmatter.

Topology:

- The umbrella branch originates at the intended final target. The final umbrella PR has the umbrella branch as head and the final target as base.
- Each phase branch originates at its declared umbrella baseline; the phase head is the head of a PR whose base is the umbrella branch.
- Branch names follow repository conventions; do not invent PR identifiers.

Each phase records: outcome, scope, exclusions, task IDs, dependencies, order, acceptance criteria, test and QA evidence, branch origin and prerequisite baseline, and PR base and head. Details may reference tasks instead of repeating them.

Rules:

- Sequential phases branch only after their predecessors are integrated into the umbrella and verified. Independent phases may share a baseline only with no output dependency and no conflicting write surface.
- When the umbrella changes, affected phase branches are updated by the repository's approved process and their checks rerun.
- A phase must pass its checks on its baseline without any unfinished future phase. Independently reviewable does not mean independently deployable or mergeable to the main target.
- Preserve each phase's review evidence. Final umbrella verification covers every plan and spec criterion, cross-phase regressions, integration, and real-surface QA; phase checks do not replace it. The final umbrella review covers integration and remaining changes, yet the aggregate diff stays large. If the repository requires a fresh full-diff review of the final PR, state that the umbrella may not solve reviewability.
- Branch creation, PRs, commits, pushes, and merges are proposals; neither planning nor plan approval authorizes them.

Commands written in a plan are proposals, not authorization. The executor must validate every command against project instructions, the current environment, and safety boundaries before running it.
