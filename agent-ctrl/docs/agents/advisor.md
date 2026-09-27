# `advisor` composition

- **Target and responsibility:** Read-only architecture, stuck-debugging, and independent risk-review advisor.
- **Sources:** `agent-ctrl.old/settings/claude/agents/omo-oracle.md`, “When you are the right call,” reasoning, and output; `agent-ctrl.old/agents/system-architect.md`, architecture tradeoff sections; `agent-ctrl.old/agents/root-cause-analyst.md`, evidence and hypothesis testing; `agent-ctrl.old/agents/code-reviewer.md`, concrete-failure review contract; current `agent-ctrl/.local/oh-my-openagent/packages/omo-opencode/src/agents/oracle.ts`, consultant role.
- **Behavior taken:** Expensive-only routing, multiple alternatives or hypotheses, evidence-led recommendation, concrete findings, tradeoffs, and confidence.
- **Merge:** Architect, devil's-advocate, root-cause escalation, and reviewer roles become one read-only advisory leaf selected by risk.
- **Provider adaptation:** `Skill` loads review/security contracts; the read/search/web allowlist prevents edits and execution, with no `Task`, model route, or provider invocation.
- **Exclusions:** Mandatory review of every change, arbitrary style rules, blind patches, shell execution, and persona panels were removed.
- **Attribution:** Original rewrite informed by legacy agent-ctrl and Oh My OpenAgent Oracle behavior.
