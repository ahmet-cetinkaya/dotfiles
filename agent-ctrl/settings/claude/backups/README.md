# Backups

Earlier Claude configurations. The `.bak` files are untracked; git ignores them.

| File | Configuration |
| --- | --- |
| `*.sandbox.bak` | The sandbox model. Every Bash command ran inside the Claude Code sandbox and sessions started through a launcher. Each tool that used Unix sockets, such as a browser, Docker, D-Bus, or nix, needed its own grant. Commit `052144a3` holds the same files. |
| `settings.json.full-guard.bak` | The settings before the sandbox model. |

## Back to the sandbox model

1. Copy each `*.sandbox.bak` file into `settings/claude`, without the suffix.
2. Add `claude() { bash "$HOME/.agent-ctrl/settings/claude/launcher.sh" "$@"; }` back to `zsh/common.zshrc` and open a new shell.
3. Run `agent-ctrl apply claude --override --no-prompt`.
