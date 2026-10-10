# `/ac:pr-address` composition

- **Target and responsibility:** Fetch, validate, classify, implement, and verify actionable feedback on the current PR.
- **Sources:** `agent-ctrl.old/commands/ac/pr-address.md`, newest-first GitHub review collection and issue-per-change flow; current `git-workflow`, `plan-execution`, `readiness-verification`, and safety authorization.
- **Behavior taken:** Resolve current PR, collect all comment classes, validate feedback against current code, show a plan before edits, apply scoped fixes, and map each feedback item to evidence.
- **Merge:** Legacy automatic fix/commit behavior is separated into local-edit authorization versus commit/push/reply/resolve side effects; executor/worker routing replaces implicit implementation.
- **Provider adaptation:** Git-host CLI is preferred (`gh` on GitHub) but feedback semantics are provider-neutral. Removed fixed persona and `/sc:*` dependencies.
- **Exclusions:** Blindly applying comments, default history rewriting, automatic commit/push/reply/resolve, plain force, and merge.
- **Attribution:** Original synthesis from the local legacy catalog and current core contracts.
