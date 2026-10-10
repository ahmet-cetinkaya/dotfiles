# agent-ctrl configuration

This is the source catalog applied by [agent-ctrl](https://github.com/ahmet-cetinkaya/agent-ctrl) to Claude Code and OpenCode. It is a deliberately small, provider-neutral engineering core rather than a restoration of the legacy catalog.

## Inventory

- `agents/`: 7 coordinated `ac-*` agents.
- `commands/ac/`: 12 explicit workflow commands: `spec`, `plan`, `plan-validate`, `run`, `fix`, `research`, `review`, `verify`, `doc`, `changelog`, `pr`, and `pr-address`.
- `skills/`: 9 descriptive skills, each with a short routing contract and focused references.
- `rules/`: 2 shared rules, `safety.md` and `clean-code.md`.
- `profiles/`: 38 optional language, framework, platform, and domain profiles, applied per project; see `docs/profiles/README.md`.
- `mcps/`: existing MCP definitions.
- `settings/claude/` and `settings/opencode/`: platform-specific settings copied by apply. `settings/omo/`: the standalone `oh-my-openagent` config, symlinked (not apply-copied) into `~/.config/opencode/.omo/`.
- `docs/`: composition indexes and one provenance record per executable artifact. Documentation is kept outside scanned artifact directories.

## Entry points

Ordinary natural-language sessions start with `lead`. It handles small, known work directly and routes specialized work only when needed. Explicit checkpoints are available as `/ac:spec`, `/ac:plan`, `/ac:plan-validate`, `/ac:run`, `/ac:fix`, `/ac:research`, `/ac:review`, `/ac:verify`, `/ac:doc`, `/ac:changelog`, `/ac:pr`, and `/ac:pr-address`.

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

Remove `--dry-run` only for an intended target. `--path` selects the source catalog, not the destination: `apply claude` always writes to `~/.claude` (override with `AGENT_CTRL_CLAUDE_HOME`), so a non-dry-run apply against an empty `--path` deletes the live `skills/`, `agents/`, and `commands/`. Applying to real home configuration is a separate user-authorized action.

## Claude and OpenCode coexistence

Claude and OpenCode both default to `lead`, and the shared catalog is rendered by agent-ctrl. OpenCode keeps `oh-my-openagent@latest` for its runtime, routing, and existing settings. Its Claude artifact import switches remain disabled, preventing duplicate commands, skills, hooks, plugins, agents, or MCP definitions. Delegating source agents use Claude's backward-compatible `Task` alias; agent-ctrl renders the OpenCode tool map in lowercase.

## Model tiers

Agent `models.claude` values are gateway combo IDs resolved by the LLM gateway at request time, with provider fallback owned by the gateway: `advisor` → `combo/max-models`, `planner` and `executor` → `combo/high-models`, `worker` and `researcher` → `combo/mid-models`, `explorer` → `combo/lite-models`, `lead` → `inherit` (the session's main model). Delegating agents omit per-invocation model overrides so these definitions stay authoritative. These IDs are meaningful only where the gateway serves them; a deployment without those combos must remap them.

Composition and licensing details are indexed in `docs/agents/`, `docs/commands/`, `docs/skills/`, and `docs/rules/`.
