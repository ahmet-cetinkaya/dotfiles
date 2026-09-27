# Pi platform-specific settings

`agent-ctrl apply pi` copies everything under this directory as-is into the resolved Pi user configuration root (`~/.pi/agent/` by default, or `$PI_CODING_AGENT_DIR`, or a `--path` override). This mirrors how `settings/claude/` and `settings/opencode/` back their platforms.

Note: this raw copy is a full byte-for-byte overwrite of the destination file, not a JSON merge (`agent-ctrl-cli`'s `copyFile` uses `fs.copyFileSync` with `overrideAction: "replace"`). Any key present in the live target but absent from the canonical file below is lost on apply, not preserved — which is why this file is kept deliberately minimal.

## Scope

- `settings.json`: the deliberate, stable Pi preferences — `theme` and the installed `packages` (`omniroute-pi-ext-integration`, `pi-subagents`). These two packages are required for OmniRoute model routing and for `ac-*` agents to render as native Pi subagents (`PiAdapter` falls back to writing agents as skills when `pi-subagents` is not declared here).

## Deliberately excluded

Pi's `settings.json` also accumulates mutable local/session state that must never be checked in or blindly overwritten by `agent-ctrl apply`: `lastChangelogVersion`, `changelogSeen`, `tipsHistory`, `tuiMode`, `defaultProvider`, `defaultModel`, `favoriteModels`, `modelThinkingLevels`, and `modelLastOnThinkingLevels`. Only the two keys above belong in the canonical source.

## `~/.omo/agent/` is a separate live target

`~/.omo/agent/` (itself a symlink target of `~/.config/opencode/.omo/agent/`) runs on the same Pi-family engine and directory layout (`AGENTS.md`, `skills/`, `prompts/`, `settings.json`) as `~/.pi/agent/`, but its `settings.json` carries a large amount of session-local state (tips history timestamps, favorite models, default provider/model, etc.) alongside the same `theme`/`packages` values.

Because `agent-ctrl apply` copies files verbatim (full overwrite, no merge), applying this directory to `~/.omo/agent/` with `--path` would destroy that state. Do not run `agent-ctrl apply pi --path ~/.omo/agent --override` against it. If the two configurations need to be reconciled, do it by hand — diff the `theme`/`packages` keys only, and leave the rest of `~/.omo/agent/settings.json` untouched.

## Apply

```bash
agent-ctrl apply pi --dry-run          # preview against ~/.pi/agent/
agent-ctrl apply pi                    # write to ~/.pi/agent/
```
