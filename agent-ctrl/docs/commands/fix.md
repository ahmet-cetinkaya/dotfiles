# `/ac:fix` composition

- **Target and responsibility:** Diagnose, minimally repair, and verify a bug or regression.
- **Sources:** [SuperClaude Framework](https://github.com/SuperClaude-Org/SuperClaude_Framework) `src/superclaude/agents/root-cause-analyst.md`, competing hypotheses; current [oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent) `packages/shared-skills/skills/debugging/SKILL.md`, observed-state debugging and repeated-failure escalation.
- **Behavior taken:** Reproduce, first invalid state, hypothesis prediction/test, owning-layer fix, red/green proof, scoped readiness, and bounded escalation.
- **Merge:** Old troubleshoot and fix stages become one command routed through `executor`, which activates `systematic-debugging`, assigns scoped explorer/researcher/worker tasks, and finishes with `readiness-verification`.
- **Provider adaptation:** Advisor routing is described by portable role name, with no provider call syntax or runtime-specific debugger mandate.
- **Exclusions:** Automatic commits, stale command references, compulsory heavyweight debugger tooling, fixed-language recipes, and unrelated cleanup were removed.
- **Attribution:** Original rewrite drawing on [SuperClaude Framework](https://github.com/SuperClaude-Org/SuperClaude_Framework) (MIT) and [oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent) (Sustainable Use License); no upstream prose is copied verbatim.
