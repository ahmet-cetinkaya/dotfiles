# `researcher` composition

- **Target and responsibility:** Read-only external/library/API researcher anchored to installed versions and authoritative citations.
- **Sources:** `agent-ctrl.old/settings/claude/agents/omo-librarian.md`, internal-versus-external boundary, version pinning, source order, and cited output; `agent-ctrl.old/agents/deep-research.md`, source evaluation and synthesis sections; `agent-ctrl.old/skills/search-first/SKILL.md`, candidate evaluation and Adopt/Extend/Compose/Build; current `agent-ctrl/.local/oh-my-openagent/packages/omo-opencode/src/agents/librarian.ts`, request classification and documentation discovery.
- **Behavior taken:** Version-first research, primary sources, changelog checks, real usage when needed, contradiction handling, and citations.
- **Merge:** The broad deep-research persona is narrowed into a practical solution and API research leaf governed by `solution-research`.
- **Provider adaptation:** `Skill` loads the shared research contract, common read/web tools replace MCP- or provider-only calls, and no model pin or delegation tool is present.
- **Exclusions:** Maximum-saturation teams, paywall bypass, implementation, installation, and hardcoded research MCP dependencies were omitted.
- **Attribution:** Original synthesis inspired by legacy agent-ctrl, ECC-derived search-first material, and Oh My OpenAgent Librarian.
