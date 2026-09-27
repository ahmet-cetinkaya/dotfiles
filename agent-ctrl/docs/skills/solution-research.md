# `solution-research` composition

- **Target and responsibility:** Evidence-led decision to adopt, extend, compose, or build.
- **Sources:** `agent-ctrl.old/skills/search-first/SKILL.md`, triggers, search order, evaluation, and decision outcomes; `agent-ctrl.old/agents/deep-research.md`, source evaluation and synthesis; `agent-ctrl.old/settings/claude/agents/omo-librarian.md`, installed-version grounding and primary sources; current `agent-ctrl/.local/oh-my-openagent/packages/omo-opencode/src/agents/librarian.ts`, version and official-document discovery.
- **Behavior taken:** Repo-first search, versioned docs, authoritative external sources, maintained usage, candidate caveats, and citations.
- **Merge:** Search-first and librarian research become one bounded decision method with a separate comparison matrix.
- **Provider adaptation:** MCP-specific channels and provider call syntax are replaced by source classes and common local/web tools.
- **Exclusions:** Silent fallback when a channel is unavailable, implementation, dependency installation, and exhaustive research teams were removed.
- **Attribution:** Original rewrite informed by ECC-derived search-first content, legacy agent-ctrl, and Oh My OpenAgent Librarian.
