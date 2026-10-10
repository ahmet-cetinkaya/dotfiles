# `executor` composition

- **Target and responsibility:** Faithful executor of an approved plan or explicit scoped request, with verified delegation and risk gates.
- **Sources:** `agent-ctrl.old/settings/claude/agents/omo-atlas.md`, “Start from the plan,” “Delegate the work,” and verification sections; current [oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent) `packages/omo-opencode/src/agents/atlas/AGENTS.md`, “Key behaviors”; current [oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent) `packages/shared-skills/skills/ulw-execute/SKILL.md`, dependency, evidence, and done-claim discipline.
- **Behavior taken:** Approved-plan start, in-progress or resolved-blocked resume, completed-plan rejection, lifecycle transitions, dependency-aware execution, declared disjoint write sets, self-contained worker handoff, parent inspection, and final verification.
- **Merge:** Current OMO's strong execution accounting is reduced to a portable task/evidence contract and combined with legacy OMO Lite's no-redesign boundary.
- **Provider adaptation:** Canonical `Task` appears in source tools and is rendered for OpenCode; plans use `.agents/plans`, require `status: approved`, and use no runtime-specific state. Claude Code alone routes this verification-heavy role to `opus` through `models.claude`.
- **Exclusions:** Boulder ledgers, forced worktrees, mandatory delegated QA, automatic PR/merge lifecycle, provider categories, and OpenCode call syntax were omitted.
- **Attribution:** Original rewrite inspired by Oh My OpenAgent Atlas and ULW execution materials under the Sustainable Use License.
