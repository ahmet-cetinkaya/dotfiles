# `/ac:plan` composition

- **Target and responsibility:** Explicit checkpoint for creating, but not executing, one decision-complete plan.
- **Sources:** `agent-ctrl.old/commands/ac/spec-plan.md`, planning-stage separation and handoff; `agent-ctrl.old/commands/ac/brainstorm.md`, ambiguity discovery; `agent-ctrl.old/skills/intent-driven-development/SKILL.md`, acceptance criteria and scope; `agent-ctrl.old/settings/claude/agents/omo-prometheus.md`, one-plan boundary; current `agent-ctrl/.local/oh-my-openagent/packages/shared-skills/skills/ulw-plan/SKILL.md`, explore-first planning.
- **Behavior taken:** Repository discovery, decision completion, durable `status: draft` plan, explicit approval transition, evidence per task, and no implementation.
- **Merge:** Legacy brainstorm/spec/plan stages collapse into one command that activates `work-planning` and routes to `planner`. A spec is an optional upstream artifact: when `/ac:spec` has produced an approved spec, `/ac:plan <spec-path>` derives the plan from it and adds a Traceability table (see `docs/commands/spec.md`).
- **Provider adaptation:** Uses `.agents/plans` instead of provider-private plan or draft paths and contains no invocation-specific syntax.
- **Exclusions:** Mandatory spec artifacts (the spec stage is opt-in through `/ac:spec`), stale namespaces, approval machinery for writing drafts, implementation handoff commands, and provider runtime state were omitted.
- **Attribution:** Original composition from legacy agent-ctrl and Oh My OpenAgent planning behavior.
