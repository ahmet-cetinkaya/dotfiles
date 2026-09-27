# `/ac:brainstorm` composition

- **Target and responsibility:** Repository-grounded Socratic discovery that turns a rough idea into an actionable brief without planning or implementation.
- **Sources:** `agent-ctrl/.local/agent-ctrl.old/commands/ac/brainstorm.md`, Explore/Validate/Specify flow; legacy `commands/sc/brainstorm.md`, one-question dialogue; legacy `skills/intent-driven-development/SKILL.md`, observable criteria; current `work-planning` question filter.
- **Behavior taken:** Need discovery, repository grounding, alternatives/tradeoffs, scope, constraints, owner-decisions, and observable success criteria.
- **Merge:** The legacy hub is rewritten as a standalone rich command routed through `planner`, `explorer`, `researcher`, and `advisor`; it stops at a brief and hands off to research or planning.
- **Provider adaptation:** Plain role/skill names replace `/sc:*`, persona metadata, and provider tool syntax.
- **Exclusions:** Automatic plan writing, implementation, rigid questionnaires, and `/ac:ship` delegation were removed.
- **Attribution:** Original synthesis from the local legacy catalog and current core contracts.
