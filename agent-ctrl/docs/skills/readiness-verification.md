# `readiness-verification` composition

- **Target and responsibility:** Fail-closed requirement fit and project-defined verification with real-surface evidence.
- **Sources:** `agent-ctrl.old/skills/verification-loop/SKILL.md`, mechanical phases and report; `agent-ctrl.old/commands/ac/verify.md`, intent-first ordering and project tool discovery; `agent-ctrl.old/skills/intent-driven-development/SKILL.md`, observable criteria; current `agent-ctrl/.local/oh-my-openagent/packages/shared-skills/skills/review-work/SKILL.md`, evidence artifacts and inconclusive outcomes.
- **Behavior taken:** Acceptance fit, applicable gates, exact evidence status, user-surface QA, stale-evidence invalidation, persistent-data risk escalation, and three-state readiness.
- **Merge:** Old reflection and verification phases become a read-only skill that does not perform code review or fixes.
- **Provider adaptation:** Commands come from each project; no active profile, language command, or provider QA syntax is assumed.
- **Exclusions:** Universal 80% coverage, timed continuous checks, auto-fix, and `READY` with blocked/missing evidence were removed.
- **Attribution:** Original rewrite based on legacy ECC-derived verification plus local and current OMO evidence behavior.
