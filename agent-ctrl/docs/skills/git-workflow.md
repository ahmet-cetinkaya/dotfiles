# `git-workflow` composition

- **Target and responsibility:** Explicitly authorized status, history, commit, rebase, and draft-PR operations.
- **Sources:** `agent-ctrl.old/skills/git-workflow/SKILL.md`, branching, commit, conflict, and collaboration guidance; `agent-ctrl.old/commands/ac/pr.md`, PR preflight and draft creation; current [oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent) `packages/shared-skills/skills/git-master/SKILL.md`, mode gate, ground truth, scoped commits, rewriting, history tools, and safety checks.
- **Behavior taken:** Mode classification, authorization separation, specific staging, local message style, upstream awareness, recovery, full PR diff, and no hook bypass.
- **Merge:** Broad legacy Git advice is narrowed into operational modes, with PR and history details in references.
- **Provider adaptation:** Standard Git and Git-host CLI behavior only; no provider agent, model, or invocation dependency.
- **Exclusions:** `git add .` guidance, automatic checkpoint/fixup commits, default rewrite, plain force push, merge, and release automation were removed.
- **Attribution:** Original synthesis from legacy agent-ctrl/ECC-derived Git content and Oh My OpenAgent Git Master.
