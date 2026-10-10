# `/ac:review` composition

- **Target and responsibility:** Read-only review with correctness always active and risk- or user-selected lenses.
- **Sources:** `agent-ctrl.old/commands/ac/review.md`, target and area routing; `agent-ctrl.old/agents/code-reviewer.md`, concrete failure and evidence requirements; `agent-ctrl.old/skills/review-{architecture,errors,performance,simplify,tests,types}/SKILL.md`, lens behaviors; current [oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent) `packages/shared-skills/skills/review-work/SKILL.md`, goal/evidence gate review.
- **Behavior taken:** Target resolution including staged, unstaged, and untracked files; selective lenses; independent high-risk review; severity ordering; and evidence-based findings.
- **Merge:** Many review skills and personas become one `risk-review` skill plus a read-only advisor, avoiding a mandatory panel.
- **Provider adaptation:** Area selection is plain command input; no provider-specific subagent or QA invocation is included.
- **Exclusions:** Auto-fix, mandatory multi-select interview, blanket review after every edit, fixed style dogma, and stale follow-up commands were removed.
- **Attribution:** Original synthesis from legacy agent-ctrl and Oh My OpenAgent review behavior.
