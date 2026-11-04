# Claude settings and launcher

This directory holds the Claude Code configuration that `agent-ctrl apply claude` puts on the machine, and the launcher that starts every session.

| File | Purpose |
| --- | --- |
| `settings.json` | Becomes `~/.claude/settings.json`: permissions, sandbox policy, environment, hooks, and status line. |
| `launcher.sh` | Starts `claude`. Adds what depends on the working directory and offers bypass mode. The `claude` function in `zsh/common.zshrc` calls it. |
| `notify.sh` | Desktop notification that the Notification and Stop hooks call. |

`settings.json` is strict JSON: Claude Code reports a comment or a trailing comma as a settings error. The reasons for each rule are in this document, not in the file. The `$schema` key points to the published schema, so an editor can complete and check the keys.

## How a session starts

`launcher.sh` builds a `--settings` JSON that Claude Code merges over `settings.json`, then runs `claude`. It does these steps in order:

1. Takes `--unsafe` out of the arguments (see [Rollback](#rollback)).
2. Asks for confirmation before it starts in `$HOME`, and refuses when there is no terminal, because the sandbox scans the whole home directory there.
3. Creates the per-user temp directory and points `BUN_TMPDIR` at it.
4. Creates the .NET and Aspire state directories and makes them writable.
5. Write-denies `~/.aspire/bin`.
6. Reads the untracked `additional-dirs.local` manifest of the main worktree (see [Linked worktrees](#linked-worktrees)).
7. Write-denies `.claude` in the start directory, the worktree, and the main worktree.
8. Makes the common git directory writable and write-denies its `hooks` and `config`, and a `core.hooksPath` directory.
9. Runs `claude --allow-dangerously-skip-permissions`, which only makes bypass mode selectable with Shift+Tab. A session never starts in it.

Every merge into the settings JSON goes through one checked function. If `jq` fails, the launcher stops. It never starts with an empty `--settings`, because that would silently drop the denies.

`CLAUDE_LAUNCHER_PRINT_SETTINGS=1 claude` prints the JSON and exits. Use it to see what a directory gets.

## Sandbox policy

`settings.json` runs every Bash command inside the Claude Code sandbox (bubblewrap on Linux). `autoAllowBashIfSandboxed` lets a sandboxed command run without a prompt.

### Secrets

- `sandbox.filesystem.denyRead` and the matching `Read(...)` deny rules block credential files, `.env` files, `~/.claude.json`, .NET user secrets, and the shell history. A denied directory such as `~/.ssh` appears empty inside the sandbox.
- `~/.nuget/NuGet/NuGet.Config` is read-denied for the Read tool only. NuGet reads it on every restore, so `sandbox.filesystem.allowRead` opens it to sandboxed commands. The `Read(...)` deny alone is not enough to keep it open: Claude Code copies that deny into the sandbox read deny, so removing only the `denyRead` entry left the file blocked. It holds no credentials on this machine (`grep -ciE 'password|token|apikey'` returned `0`). Check that again before adding a private feed with a login to it.
- The Read tool is also denied `.env.*` files (including `.env.example`) and credential paths that do not exist on this machine, such as `~/.netrc`, `~/.git-credentials`, `~/.kube`, and `~/.azure`. Those stay out of `denyRead`: the sandbox answers a read of a denied missing path with "access denied", which breaks tools that probe for it (git reads `~/.netrc`).
- `sandbox.credentials.envVars` removes the gateway and API tokens from the environment of sandboxed commands.
- Repository settings cannot loosen the sandbox. The launcher passes `allowUnsandboxedCommands: false` with `--settings`, which makes the sandbox admin-required. Claude Code then ignores `allowRead` for a denied path, and every `allowWrite`, `excludedCommands`, and `allowedDomains` entry, in a repository's `.claude/settings.json` and `.claude/settings.local.json`. A grant belongs in `settings.json` or in the launcher.

### Writes

- Writes stay in the working directory, the temp directory, the npm cache `~/.npm`, and the .NET, NuGet, and Aspire state directories, including the .NET lock directory under `$XDG_RUNTIME_DIR`. The launcher creates these directories first, because the sandbox cannot create a missing directory it may write.
- Shell startup files, `~/Configs/zsh`, `~/Configs/nixos`, the user `bin` directories, `~/.dotnet/tools`, `~/.aspire/bin`, systemd and autostart, the Claude settings, and `settings/claude` itself are write-denied.
- `~/.aspire` is writable for Aspire state, but its `bin` comes first on `PATH`. A file planted there would run instead of `git` or `sudo`. The launcher writes the deny next to the grant, so the two cannot ship apart.
- The Edit and Write tools run outside the sandbox. `Edit(...)` ask rules cover the same persistence paths: shell startup files, systemd and autostart, every `bin` directory on `PATH`, git and `gh` configuration, `~/.ssh`, the Claude settings, agents, commands, skills, hooks, and plugins, every `.claude/settings*.json`, `.mcp.json`, and `.git`.

### Network

`allowedDomains` holds the hosts every session needs, including GitHub, npm, NuGet, container registries, and the .NET download hosts. Any other host asks once (`strictAllowlist` is `false`), so a listed domain only removes a prompt. Known exfiltration hosts in `deniedDomains` are blocked.

### Outside the sandbox

- Commands that need credentials or host sockets are in `excludedCommands`. `git commit`, `git fetch`, `git pull`, and `git branch` run there without a prompt, so signed commits, SSH remotes, and branch cleanup work. `git config` stays sandboxed, so a session cannot set `core.hooksPath`.
- The rest of the daily loop runs without a prompt too: `git push`, `aspire`, and a fixed list of subcommands. For `gh` they are `pr`, `issue`, `run`, `workflow`, `search`, `repo`, `release`, `api`, `auth status`, and `status`. For `podman` and `docker` they are `ps`, `logs`, `images`, `inspect`, `stop`, `rm`, `pull`, and `run`.
- Every other `gh`, `podman`, and `docker` subcommand runs inside the sandbox, which has no token and no container socket, so it fails instead of running with full access. This covers `gh alias`, `gh extension`, `gh config`, `gh gist`, `gh secret`, key commands, `gh auth login` and `token`, and `podman` or `docker` `build`, `create`, `cp`, `exec`, `kube play`, and `unshare`. Run them in your own terminal, or add the subcommand to `excludedCommands` and `allow` after a review.
- A command with an option before the subcommand, such as `gh -R owner/repo pr view`, does not match the list and fails the same way.
- A command matches only when it runs on its own. Inside a pipe or a `&&` chain it stays sandboxed and fails to authenticate. Shorten output with the tool's own flags.
- `allowUnsandboxedCommands` is `false`, so a sandboxed command that fails cannot ask to retry outside the sandbox. The launcher sets it as well as `settings.json`, because the launcher's value wins.
- `GIT_ALLOW_PROTOCOL=https:ssh` lets git use only HTTPS and SSH. Without it, `git fetch --upload-pack='<command>' <local path>` runs the command on this machine; with it, git refuses the local path with `transport 'file' not allowed`. The cost is that `fetch`, `pull`, and `clone` from a local path or a `file://` URL stop working.

### Commands that ask

Only critical commands ask, in every mode, including bypass:

- a force push (also `+refspec` and `-fu`), a delete push (also `-d`), a prune push, or a mirror push;
- a push, fetch, or pull that sets `--receive-pack`, `--exec`, or `--upload-pack`, which run a command;
- `gh pr merge`; deleting, archiving, renaming, or editing a repository; creating or deleting a release; deleting an issue;
- any `gh api` call, because it reaches any endpoint with your token;
- `gh secret`, `gh auth token`, `gh auth status -t`, SSH and GPG keys, every `gh extension` command, `gh alias`, `gh config set`, and `gh gist create`, also through the `ext` and `gist new` aliases;
- `gh` with `--body-file` or `-F` and a path that starts with `/` or `~`, because it sends that file to GitHub; a path inside the repository does not ask;
- `podman` and `docker` `system prune`, volume removal, a `run` that mounts host paths or is privileged, `podman run --env-host`, and `podman unshare`;
- `aspire deploy` and `agent-ctrl apply`.

An ask rule always wins over an allow rule, so ask rules stay narrow.

### Hooks

Hooks run when the unsandboxed git commands run. For that reason `.git/hooks`, `.git/config`, and a `core.hooksPath` directory are write-denied to sandboxed commands.

### Bypass mode

Bypass mode is selectable with Shift+Tab. In a recorded check, an unsandboxed `cat` of a read-denied path was still refused in bypass mode. Commands that read a file indirectly are not guaranteed to match a deny rule, and bypass approves every excluded command. Bypass therefore weakens the secret guarantee. Use it only for narrow, trusted work.

## Environment for .NET and Bun

The sandbox forbids creating Unix sockets and masks missing paths, which breaks several build tools without a clear error. `settings.json` sets these in `env`. They belong to .NET, not to Claude Code, which only passes them on:

| Variable | Effect |
| --- | --- |
| `RestoreBuildInParallel=false`, `BuildInParallel=false` | Projects build one after another in the main process. |
| `UseSharedCompilation=false` | No Roslyn compiler server, which needs a Unix socket. |
| `MSBUILDDISABLENODEREUSE=1` | No MSBuild worker nodes, which need Unix sockets. |
| `EnableSourceControlManagerQueries=false` | SourceLink does not read `.gitmodules`. |
| `DOTNET_TieredPGO=0` | The runtime skips profile-guided JIT instrumentation. Every `csc` process starts faster; an incremental build took 13 s instead of 18 s in four runs. It applies to every .NET process Claude starts, so a long-running app started by `aspire run` reaches its peak speed a little later. |

Without the first three, a solution with several projects fails with `Build FAILED` and `0 Error(s)`. Without the last one, the build stops after about a second, because the sandbox masks a missing `.gitmodules`. The costs are slower parallel builds (an incremental build takes about 13 s with `DOTNET_TieredPGO=0`, against 4 to 5 s with parallel nodes) and assembly versions without a commit hash. No setting gives a parallel build without Unix sockets: `dotnet build -mt` ran all 6793 task launches of one build in an external task host, which needs a socket, and the Linux sandbox cannot allow sockets by path. Re-test `-mt` after an SDK update. Allowing Unix sockets instead would also open the podman, D-Bus, and ssh-agent sockets, so it is not done.

The launcher sets `BUN_TMPDIR` to the writable per-user temp directory. Bun-packaged tools such as Tailwind need it to extract native modules. The path holds the user ID, so it cannot sit in `settings.json`.

## Linked worktrees

The launcher makes the common git directory writable, so commits work from linked worktrees and subdirectories. An untracked `additional-dirs.local` file in `.claude` of the main worktree lists symlinks whose targets a linked worktree may write. The launcher ignores the file when it is tracked, when `.claude` is a symlink, and for entries that are absolute, that go upward, that are not symlinks, that the user does not own, or that point to a sensitive directory. Edits to the file through the Edit tool ask.

## Rollback

`claude --unsafe` starts one session with the sandbox off. It is the way out when the sandbox blocks work. That session does not offer bypass mode, so the permission prompts stay as the remaining guard. The launcher removes every `--unsafe` argument, wherever it appears. Run the `evals/ac` harness from an `--unsafe` session or a plain terminal, because its nested `claude -p` runs need the gateway token.

The unsandboxed retry is closed. Moving these rules into the Nix managed settings, with `failIfUnavailable: true`, is deferred until two weeks of normal work pass without an `--unsafe` session.

## Known limits

- **Excluded commands run with full access.** `git commit`, `git fetch`, `git pull`, `git push`, `aspire`, and the listed `gh`, `podman`, and `docker` subcommands can each run code: a hook in a nested repository, `aspire run` of an edited AppHost, a container started with options that no ask rule names, such as `--device` or `--userns`. Ask rules match command text, so they narrow this and do not close it. Closing it for commit, push, and `aspire` would cost a prompt for each, and is a separate decision.
- **`git fetch` and `git pull` stay outside the sandbox.** The configuration of a nested repository can make them run a command.
- **A writable package cache runs unsandboxed.** `~/.nuget/packages` is writable in every session. MSBuild files in that cache run when an excluded command such as `aspire run` builds, so a poisoned package can reach unsandboxed execution.
- **`.claude/worktrees/` is not writable.** The `.claude` deny covers it. Create worktrees in sibling directories instead.
- **Do not deny a glob over `/proc`.** A `Read(...)` deny is copied into the sandbox read deny, and the sandbox expands every glob into mount arguments (about three per path, at most 9000). `Read(//proc/**/environ)` matches every process and thread, so no Bash command starts any more. `/proc/<pid>/environ` stays readable to the Read tool.
- **Do not mask `GH_TOKEN`.** With `mask` alone the proxy cannot substitute the real token, and `gh` stays outside the sandbox. `sandbox.network.tlsTerminate` made the sandbox not start at all, and the commands ran unsandboxed without an error. Never add that setting without `failIfUnavailable: true`, and run a `touch` outside the working directory afterwards.

## Changing the policy

1. Edit `settings.json` or `launcher.sh`.
2. Run `bash -n launcher.sh` and `jq -e . settings.json`.
3. Run `CLAUDE_LAUNCHER_PRINT_SETTINGS=1 claude` in a repository and read the result.
4. Apply with `agent-ctrl apply claude --override --no-prompt`, without `--path`. The launcher is live as soon as the file changes, because `~/.agent-ctrl` links to this directory, but `settings.json` only changes on apply. Apply right after a launcher change.
5. In a new session, run a command in the sandbox. A sandbox that cannot start fails every Bash command, so this check comes first.
6. Run the .NET restore and build check in a repository that uses private feeds, and confirm the new rules ask or allow as intended.
