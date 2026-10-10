# `/ac:verify` composition

- **Target and responsibility:** Read-only fail-closed readiness report with `READY`, `NOT_READY`, or `INCONCLUSIVE`.
- **Sources:** `agent-ctrl.old/commands/ac/verify.md`, intent-first then mechanical gate structure; `agent-ctrl.old/skills/verification-loop/SKILL.md`, build/type/lint/test/security/diff phases; current [oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent) `packages/shared-skills/skills/review-work/SKILL.md`, real-surface evidence and inconclusive handling; `agent-ctrl.old/skills/intent-driven-development/SKILL.md`, observable acceptance fit.
- **Behavior taken:** Requirement fit, project-discovered checks, evidence statuses, real-surface QA, and fail-closed verdicts.
- **Merge:** Reflection and mechanical verification become one `readiness-verification` contract without launching code review.
- **Provider adaptation:** Commands are discovered from each project and no active profile or provider tool is assumed.
- **Exclusions:** Global 80% coverage, auto-fix, stale command dependencies, profile requirement, and optimistic success with missing evidence were removed.
- **Attribution:** Original rewrite based on legacy agent-ctrl/ECC-derived verification and current OMO review evidence concepts.
