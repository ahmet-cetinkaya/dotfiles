# `worker` composition

- **Target and responsibility:** Leaf implementer for one scoped task with minimum correct changes and local evidence.
- **Sources:** `agent-ctrl.old/settings/claude/agents/omo-sisyphus-junior.md`, “You do not delegate,” “You do not expand scope,” execution, and verification; current [oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent) `packages/omo-opencode/src/agents/sisyphus-junior/AGENTS.md`, overview and non-delegating executor behavior; `agent-ctrl.old/rules/minimal-engineering.md.disabled`, “Trace First” and “Decision Ladder.”
- **Behavior taken:** No delegation, strict scope, owning-layer fix, local conventions, scoped checks, and honest blockers.
- **Merge:** Many old frontend/backend/devops/test/doc implementer personas collapse into one task-shaped worker whose role comes from context and acceptance criteria.
- **Provider adaptation:** Leaf frontmatter intentionally omits `Task`; `Skill` permits focused policy loading. Claude Code alone routes this focused implementation role to `sonnet` through `models.claude`, while other platforms remain unpinned.
- **Exclusions:** OMO category/model routing, permission to spawn research children, fixed language rules, automatic commits, and unrelated cleanup were removed.
- **Attribution:** Original concise synthesis of OMO Lite worker and legacy minimal-engineering behavior; no verbatim prompt copy.
