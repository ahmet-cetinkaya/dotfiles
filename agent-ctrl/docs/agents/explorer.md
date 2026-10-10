# `explorer` composition

- **Target and responsibility:** Read-only internal search returning concise `file:line` and call-site evidence.
- **Sources:** `agent-ctrl.old/settings/claude/agents/omo-explore.md`, read-only Bash, search, and report sections; `agent-ctrl.old/agents/code-explorer.md`, “Entry Point Discovery,” “Execution Path Tracing,” and dependencies; `agent-ctrl.old/skills/iterative-retrieval/SKILL.md`, progressive refinement and stop guidance; current [oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent) `packages/omo-opencode/src/agents/explore.ts`, repository exploration role.
- **Behavior taken:** Query translation, broad-to-narrow search, definition/caller tracing, evidence pointers, and explicit not-found results.
- **Merge:** Deep legacy exploration is bounded by OMO's fast search role and returned as evidence rather than a generic architecture report.
- **Provider adaptation:** Read-only common tools and shell restrictions replace provider-specific search calls; the leaf has no `Task`. Claude Code alone routes this fast lookup role to `haiku` through `models.claude`.
- **Exclusions:** Codegraph dependency, network access, mutation commands, exhaustive surveys, and provider background-task syntax were excluded.
- **Attribution:** Original rewrite informed by legacy agent-ctrl and Oh My OpenAgent exploration behavior.
