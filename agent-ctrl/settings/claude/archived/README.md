# Archived Claude configurations

Earlier configurations, kept as reference. Each topic has its own folder. Git history holds the exact files; these copies replace the home server address with `HOME_SERVER_HOST` and the project directory in the home directory with `PROJECT_DIR`.

| Folder | Configuration |
| --- | --- |
| `sandbox/` | The sandbox model. Every Bash command ran inside the Claude Code sandbox and sessions started through a launcher. Each tool that used Unix sockets, such as a browser, Docker, D-Bus, or nix, needed its own grant. |
| `full-guard/` | The settings before the sandbox model. |

## Back to the sandbox model

1. Copy the files of `sandbox/` into `settings/claude`.
2. Replace `HOME_SERVER_HOST` in `settings.json` with the home server address and `PROJECT_DIR` in `launcher.sh` with the project directory.
3. Make `claude()` in `zsh/common.zshrc` call that launcher, and open a new shell.
4. Run `agent-ctrl apply claude --override --no-prompt`.
