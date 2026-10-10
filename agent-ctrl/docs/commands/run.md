# `/ac:run` composition

- **Target and responsibility:** Execute an approved plan or already-clear scoped request without Git delivery.
- **Sources:** `agent-ctrl.old/commands/ac/implement.md`, standalone implementation and existing-convention flow; `agent-ctrl.old/commands/ac/spec-implement.md`, planned task execution; `agent-ctrl.old/commands/ac/ship.md`, end-to-end verification ideas; `agent-ctrl.old/settings/claude/agents/omo-atlas.md`, faithful plan execution; current [oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent) `packages/shared-skills/skills/ulw-execute/SKILL.md`, dependency and evidence discipline.
- **Behavior taken:** Approved-plan start, in-progress or resolved-blocked resume, draft/completed/ambiguous rejection, clear-input gate for direct requests, executor handoff, dependency-aware completion, evidence validation, and risk review.
- **Merge:** Multiple implement/ship/start-work paths become one execution command backed by `plan-execution`.
- **Provider adaptation:** Agent names and plan path are shared across Claude/OpenCode; no provider task-call syntax is embedded.
- **Exclusions:** Automatic commits, worktrees, push/PR/merge, maximum parallelism, stale command chains, and plan redesign were excluded.
- **Attribution:** Original synthesis drawing on legacy agent-ctrl and Oh My OpenAgent execution material.
