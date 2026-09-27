# agent-ctrl configuration

This is the source catalog applied by [agent-ctrl](https://github.com/ahmet-cetinkaya/agent-ctrl) to Claude Code and OpenCode. It is a deliberately small, provider-neutral engineering core rather than a restoration of the legacy catalog.

## Inventory

- `agents/`: 7 coordinated `ac-*` agents.
- `commands/ac/`: 13 explicit workflow commands: `brainstorm`, `spec`, `plan`, `plan-validate`, `run`, `fix`, `research`, `review`, `verify`, `doc`, `changelog`, `pr`, and `pr-address`.
- `skills/`: 8 descriptive skills, each with a short routing contract and focused references.
- `rules/safety.md`: 1 shared safety rule.
- `profiles/`: intentionally empty in this first version; language and framework conventions are discovered from each project.
- `mcps/`: existing MCP definitions.
- `settings/claude/`, `settings/opencode/`, and `settings/pi/`: platform-specific settings copied by apply. `settings/omo/`: the standalone `oh-my-openagent` config, symlinked (not apply-copied) into `~/.config/opencode/.omo/`.
- `docs/`: composition indexes and one provenance record per executable artifact. Documentation is kept outside scanned artifact directories.

## Entry points

Ordinary natural-language sessions start with `lead`. It handles small, known work directly and routes specialized work only when needed. Explicit checkpoints are available as `/ac:brainstorm`, `/ac:spec`, `/ac:plan`, `/ac:plan-validate`, `/ac:run`, `/ac:fix`, `/ac:research`, `/ac:review`, `/ac:verify`, `/ac:doc`, `/ac:changelog`, `/ac:pr`, and `/ac:pr-address`.

Durable plans live at `.agents/plans/<slug>.md`, independent of either provider's private state directories. `/ac:plan` writes `status: draft` but never implements it; only explicit approval changes it to `status: approved`. `/ac:run` starts approved plans, resumes recorded in-progress or resolved-blocked plans, rejects draft/completed/ambiguous plans, and executes clear scoped requests without committing or pushing.

Spec-driven work is optional and adds one artifact upstream of the plan. `/ac:spec` writes a behavior spec (EARS requirements, Given/When/Then scenarios, measurable success criteria) to `specs/changes/<NNNN>-<slug>/SPEC.md`; re-running it on the draft asks targeted clarifying questions. After explicit approval, `/ac:plan <spec-path>` derives the plan with a traceability table, `/ac:plan-validate` checks spec coverage, `/ac:run` records deviations in the spec instead of silently changing requirements, and `/ac:verify` demands evidence per criterion. On ship the change's deltas merge into the living spec at `specs/<capability>/SPEC.md` and the change directory is archived unchanged.

## Delegation graph

- `lead` may call planner, executor, worker, explorer, researcher, or advisor.
- `planner` may call explorer, researcher, or advisor only.
- `executor` may call worker, explorer, researcher, or advisor only.
- `worker`, `explorer`, `researcher`, and `advisor` are leaves and never delegate.
- No child calls back to `lead`; the graph has no cycle.

Review depth is risk-based. Correctness and scoped verification remain mandatory, while independent advisor review is added for security, authentication, sensitive data, schema or migration, shared API, CI, and critical user-facing changes. Verification is fail-closed: missing evidence cannot produce `READY`. Project-defined quality gates take precedence; there is no global coverage percentage or blanket language policy.

## Apply and inspect

Run catalog inspection from this directory:

```bash
agent-ctrl agent ls .
agent-ctrl command ls .
agent-ctrl skill ls .
agent-ctrl rule ls .
```

Preview before writing:

```bash
agent-ctrl apply claude --path /tmp/agent-ctrl-claude --override --no-prompt --dry-run
agent-ctrl apply opencode --path /tmp/agent-ctrl-opencode --override --no-prompt --dry-run
```

Remove `--dry-run` only for an intended target. Use a temporary path for sandbox validation; applying to real home configuration is a separate user-authorized action.

## Claude and OpenCode coexistence

Claude and OpenCode both default to `lead`, and the shared catalog is rendered by agent-ctrl. OpenCode keeps `oh-my-openagent@latest` for its runtime, routing, and existing settings. Its Claude artifact import switches remain disabled, preventing duplicate commands, skills, hooks, plugins, agents, or MCP definitions. Delegating source agents use Claude's backward-compatible `Task` alias; agent-ctrl renders the OpenCode tool map in lowercase. Source prompts contain no provider model pins or provider-only invocation syntax.

Composition and licensing details are indexed in `docs/agents/`, `docs/commands/`, `docs/skills/`, and `docs/rules/`.
