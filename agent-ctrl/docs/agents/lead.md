# `lead` composition

- **Target and responsibility:** Default session owner for direct bounded work, specialist routing, and final evidence.
- **Sources:** `agent-ctrl.old/settings/claude/OMO_LITE_CLAUDE.md`, “Agent roster and delegation shape”; `agent-ctrl.old/settings/claude/agents/omo-sisyphus.md`, “Execute bounded work directly,” “How to delegate,” “Depth limit,” and “Verify once”; current `agent-ctrl/.local/oh-my-openagent/packages/omo-opencode/src/agents/sisyphus/` prompt family, orchestration and verification sections.
- **Behavior taken:** One-known-file, local and reversible fast path; self-contained delegation; acyclic depth; parent verification; and risk-triggered depth.
- **Merge:** Combines the legacy portable seven-role shape with current OMO orchestration discipline, but uses the shared focused skills as policy.
- **Provider adaptation:** Uses canonical `Task` in source frontmatter; agent-ctrl lowers tool keys for OpenCode. Names and prompt prose are provider-neutral and contain no model route.
- **Exclusions:** Mandatory delegation for every multi-step or UI change, background-task syntax, provider categories, model tiers, and blanket review fan-out were omitted.
- **Attribution:** Behavior is an original concise rewrite inspired by Oh My OpenAgent (Sustainable Use License) and the local OMO Lite adaptation; no prompt is copied verbatim.
