# Claude settings

This directory holds the Claude Code configuration that `agent-ctrl apply claude` puts on the machine.

| File | Purpose |
| --- | --- |
| `settings.json` | Becomes `~/.claude/settings.json`: permissions, auto mode rules, environment, hooks, and status line. |
| `notify.sh` | Desktop notification that the Notification and Stop hooks call. |

`settings.json` is strict JSON: Claude Code reports a comment or a trailing comma as a settings error. The reasons for each rule are in this document. The `$schema` key points to the published schema, so an editor can complete and check the keys.

## Guard model

Sessions start in auto mode (`permissions.defaultMode: "auto"`) with the Bash sandbox off. A classifier model reviews each action that no rule decides, and blocks it when it goes beyond the request. No tool needs its own grant, so a new project or tool needs no change here.

The guards, in the order Claude Code applies them:

1. **`permissions.deny`.** `Read(...)` rules block the Read tool from credential files, `.env` files that hold values, `~/.claude.json`, the NuGet config, .NET user secrets, and the shell history. A deny rule holds in every mode and is evaluated before the classifier. `.env.example`, `.env.sample`, and `.env.template` stay readable, because a session needs them to learn the settings a project expects.
2. **`permissions.ask`.** A few actions always ask, in every mode: `gh secret`, `gh auth token`, deleting a repository or a release, `gh pr merge`, `agent-ctrl apply`, and edits to `settings/claude`, `~/Configs/zsh`, and `~/Configs/nixos/modules/apps/ai`.
3. **The classifier.** `autoMode.classifyAllShell` is `true`, so every shell command goes to the classifier and no allow rule lets one skip it. `settings.json` has no Bash allow rules.
   - `autoMode.soft_deny` keeps the built-in rules (`"$defaults"`) and adds two: reading a credential file through a shell command, and printing the environment or a secret variable. The built-in rules already block running code from a URL (`curl | bash`), sending data to untrusted hosts, force pushes, persistence in shell profiles, production deploys, and changes to Claude's own configuration.
   - `autoMode.environment` keeps the built-in entries and adds one: the machine runs without a sandbox and holds real credentials. It names no organization, project, or address; the built-in entries already trust the repository a session starts in and its remotes.
4. **`GIT_ALLOW_PROTOCOL=https:ssh`** in `env`. Git then refuses a local path or `file://` remote, which could run a command through `--upload-pack`. The cost is that `fetch`, `pull`, and `clone` from a local path stop working.

Run `claude auto-mode config` to see the effective rules, and `claude auto-mode critique` for feedback on the custom ones.

## Environment

| Variable | Effect |
| --- | --- |
| `ASPIRE_CLI_START_TIMEOUT=600` | `aspire run` waits up to 600 s, not 120 s, for the AppHost to connect. The wait does not count the build. |
| `GIT_ALLOW_PROTOCOL=https:ssh` | See the guard list above. |
| `PYTHONSAFEPATH=1` | Python does not import from the script directory or the current directory first. |

## Known limits

- **A shell command can read a credential file.** The Read tool deny does not cover `cat`. Only the classifier stops it, and Anthropic states that the classifier "doesn't replace an operating-system control such as sandboxing".
- **Secret environment variables are visible to commands.** Without the sandbox, `credentials.envVars` does not apply, so the gateway token is in the environment of every command. The classifier blocks printing it.
- **Bypass mode turns the classifier off.** Nothing offers it at startup any more. Do not switch to it with real credentials on the machine.
- **Untrusted code needs other isolation.** For a downloaded repository or a pull request from outside, use a container.

## Changing the policy

1. Edit `settings.json`.
2. Run `jq empty settings.json` and, after an `autoMode` change, `claude auto-mode config` to confirm that `"$defaults"` still pulls in the built-in rules.
3. Apply with `agent-ctrl apply claude --override --no-prompt`, without `--path`, as a command on its own.
