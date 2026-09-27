# `planner` composition

- **Target and responsibility:** Non-implementing planner that writes one decision-complete `.agents/plans` handoff.
- **Sources:** `agent-ctrl.old/settings/claude/agents/omo-prometheus.md`, “Interview first,” “Explore only what blocks the plan,” “Write exactly one plan file,” and “Boundaries”; `agent-ctrl.old/agents/requirements-analyst.md`, requirements and acceptance analysis sections; `agent-ctrl.old/skills/intent-driven-development/SKILL.md`, “When to Activate,” acceptance criteria, and handoff; current `agent-ctrl/.local/oh-my-openagent/packages/shared-skills/skills/ulw-plan/SKILL.md`, decision-complete planning and approval boundaries.
- **Behavior taken:** Repo-first discovery, few non-discoverable questions, explicit decisions, per-task evidence, `draft → approved` lifecycle, and no implementation.
- **Merge:** Requirements and planning personas are consolidated into one role backed by `work-planning` rather than separate spec stages.
- **Provider adaptation:** Plan storage moved from provider-private paths to `.agents/plans`; `status: draft` is written first and only explicit approval makes it executable; only canonical `Task` delegation to three read-only roles is described.
- **Exclusions:** OMO draft/Boulder state, OpenCode invocation examples, mandatory interview ceremony, stale spec namespaces, and model pins were excluded.
- **Attribution:** Original synthesis drawing on legacy agent-ctrl and Oh My OpenAgent planning behavior; no upstream prose is reproduced verbatim.
