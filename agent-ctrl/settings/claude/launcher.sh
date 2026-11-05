#!/usr/bin/env bash
# Launch Claude Code inside its Bash sandbox with what depends on the working directory.
# The sandbox policy lives in settings.json; this launcher adds symlink grants from
# <main-worktree>/.claude/additional-dirs.local, git access from linked worktrees, the
# directories .NET tools need to exist, and a write deny on <main-worktree>/.claude so a
# session cannot widen the next one.
# `claude --unsafe` starts one session with the sandbox off, as a rollback.
set -u

readonly WRITE_DENY_PATH='["sandbox","filesystem","denyWrite"]'
readonly WRITE_ALLOW_PATH='["sandbox","filesystem","allowWrite"]'

is_unsafe=0
forwarded_args=()
for arg in "$@"; do
  if [[ "$arg" == --unsafe ]]; then
    is_unsafe=1
  else
    forwarded_args+=("$arg")
  fi
done

# Apply a jq filter to settings_json; extra arguments are passed as jq options.
# Without the check a jq failure would pass an empty --settings and silently drop the denies.
update_settings() {
  local merged
  if ! merged=$(jq -c "$@" <<<"$settings_json") || [[ -z "$merged" ]]; then
    printf '%s\n' 'claude: settings merge failed; refusing to start' >&2
    exit 1
  fi
  settings_json=$merged
}

# Append values to the array at a JSON path in settings_json, keeping it unique.
append_setting() {
  local json_path=$1
  shift
  update_settings --argjson path "$json_path" \
    'setpath($path; ((getpath($path) // []) + $ARGS.positional | unique))' --args "$@"
}

if [[ "$PWD" == "$HOME" ]]; then
  printf '%s\n' 'claude: launching from $HOME may freeze (sandbox scans the whole home dir). cd into a project first.' >&2
  if [[ ! -t 0 ]]; then
    exit 1
  fi
  read -r -n 1 -p 'Continue anyway? [y/N] ' answer
  printf '\n'
  [[ "$answer" == [yY] ]] || exit 1
fi

# Give Claude a stable per-user sandbox temp root, then point Bun's native-addon
# extraction there. This fixes Bun-packaged tools (for example Tailwind/lightningcss)
# without widening the filesystem boundary.
sandbox_tmp=${CLAUDE_CODE_TMPDIR:-$HOME/.cache/claude-code/tmp}
mkdir -p "$sandbox_tmp"
chmod 700 "$sandbox_tmp"
export CLAUDE_CODE_TMPDIR="$sandbox_tmp"
# The sandbox only lets commands write the per-user subdirectory Claude Code creates
# under the temp root, not the root itself, so Bun must extract there.
user_tmp="$sandbox_tmp/claude-$(id -u)"
mkdir -p "$user_tmp"
chmod 700 "$user_tmp"
export BUN_TMPDIR="${BUN_TMPDIR:-$user_tmp}"

settings_json='{"sandbox":{"allowUnsandboxedCommands":false}}'

# .NET and Aspire write these: `dotnet run file.cs` keeps its virtual project in runfile,
# named mutexes use /tmp/.dotnet/shm or, when XDG_RUNTIME_DIR is set,
# $XDG_RUNTIME_DIR/.dotnet/shm, a cold restore writes the package caches, and Aspire keeps
# its logs and state in ~/.aspire. The sandbox cannot create a missing directory it may
# write, so they are created first.
dotnet_state_dirs=("$HOME/.local/share/dotnet/runfile" "$HOME/.nuget/packages" \
  "$HOME/.local/share/NuGet" "$HOME/.dotnet" "$HOME/.aspire" "/tmp/.dotnet/shm" \
  "$HOME/.insurup/dev-env")
[[ -n "${XDG_RUNTIME_DIR:-}" ]] && dotnet_state_dirs+=("$XDG_RUNTIME_DIR/.dotnet")
mkdir -p "${dotnet_state_dirs[@]}"
append_setting "$WRITE_ALLOW_PATH" "${dotnet_state_dirs[@]}"
# MSBuild imports every file in this user directory into each project. The file turns the
# build parallelism off only where SANDBOX_RUNTIME is set, which is inside the sandbox, so
# the sandbox needs no global build setting that would also slow `aspire run`. The directory
# stays outside the sandbox write list, so a sandboxed command cannot change the file.
msbuild_import_dir="$HOME/.local/share/Microsoft/MSBuild/Current/Imports/Microsoft.Common.props/ImportBefore"
msbuild_import_source="${BASH_SOURCE[0]%/*}/sandbox-no-sockets.props"
mkdir -p "$msbuild_import_dir"
cmp -s "$msbuild_import_source" "$msbuild_import_dir/sandbox-no-sockets.props" ||
  cp -f "$msbuild_import_source" "$msbuild_import_dir/"

# ~/.aspire/bin comes first on PATH, so a file planted there would run instead of git or
# sudo. The deny sits next to the grant so the two can never ship apart.
append_setting "$WRITE_DENY_PATH" "$HOME/.aspire/bin"

worktree_root=$(git -C "$PWD" rev-parse --show-toplevel 2>/dev/null || true)
common_git_dir=$(git -C "$PWD" rev-parse --path-format=absolute --git-common-dir 2>/dev/null || true)
main_worktree=
additional_dirs=()

if [[ -n "$worktree_root" && -n "$common_git_dir" && "${common_git_dir##*/}" == .git ]]; then
  main_worktree=${common_git_dir%/.git}
  manifest="$main_worktree/.claude/additional-dirs.local"

  # The manifest is a local trust decision. A tracked manifest or symlinked .claude
  # directory is repository-controlled and therefore cannot widen access.
  if [[ -f "$manifest" && ! -L "$main_worktree/.claude" ]] &&
     ! git -C "$main_worktree" ls-files --error-unmatch -- .claude/additional-dirs.local >/dev/null 2>&1; then
    while IFS= read -r entry || [[ -n "$entry" ]]; do
      entry=${entry%$'\r'}
      [[ -z "$entry" || "$entry" == \#* ]] && continue

      # Entries must be relative and may not traverse upward. The target itself may
      # resolve into the main checkout, a parent directory, or a sibling directory.
      if [[ "$entry" == /* || "$entry" == .. || "$entry" == ../* || "$entry" == */../* || "$entry" == */.. ]]; then
        printf 'claude: ignoring unsafe additional-dir entry: %s\n' "$entry" >&2
        continue
      fi

      link_path="$worktree_root/$entry"
      if [[ ! -L "$link_path" ]]; then
        printf 'claude: additional-dir entry is not a symlink: %s\n' "$entry" >&2
        continue
      fi
      target=$(readlink -f -- "$link_path" 2>/dev/null || true)
      if [[ -z "$target" || ! -d "$target" ]]; then
        printf 'claude: additional-dir target is not a directory: %s\n' "$entry" >&2
        continue
      fi
      if [[ $(stat -c %u -- "$target" 2>/dev/null) != "$EUID" ]]; then
        printf 'claude: refusing additional-dir not owned by this user: %s\n' "$target" >&2
        continue
      fi

      case "$target" in
        "$HOME"|"$HOME"/.ssh|"$HOME"/.ssh/*|"$HOME"/.gnupg|"$HOME"/.gnupg/*|\
        "$HOME"/.aws|"$HOME"/.aws/*|"$HOME"/.config|"$HOME"/.config/*|\
        "$HOME"/.docker|"$HOME"/.docker/*|"$HOME"/.claude|"$HOME"/.claude/*|\
        /etc|/etc/*|/run|/run/*|/proc|/proc/*|/sys|/sys/*|/dev|/dev/*)
          printf 'claude: refusing sensitive additional-dir target: %s\n' "$target" >&2
          continue
          ;;
      esac

      # No grant is needed when the resolved target already sits in this worktree.
      [[ "$target" == "$worktree_root" || "$target" == "$worktree_root"/* ]] && continue
      additional_dirs+=("$target")
    done < "$manifest"
  fi
fi

if (( ${#additional_dirs[@]} )); then
  update_settings \
    '.permissions.additionalDirectories = ((.permissions.additionalDirectories // []) + ($ARGS.positional | unique))' \
    --args "${additional_dirs[@]}"
fi

# A session often works across the checkouts of one repository, for example a test in a
# sibling worktree. Every worktree of the repository is writable. Its .git file points git
# at the shared hooks and config, and unsandboxed git commands follow it, so it stays
# write-denied, and its .claude is denied below.
repo_worktrees=()
if [[ -n "$main_worktree" ]]; then
  while IFS= read -r worktree_path; do
    [[ -d "$worktree_path" && ! -L "$worktree_path" ]] && repo_worktrees+=("$worktree_path")
  done < <(git -C "$worktree_root" worktree list --porcelain 2>/dev/null | sed -n 's/^worktree //p')
fi
if (( ${#repo_worktrees[@]} )); then
  append_setting "$WRITE_ALLOW_PATH" "${repo_worktrees[@]}"
  linked_git_files=()
  for worktree_path in "${repo_worktrees[@]}"; do
    [[ -f "$worktree_path/.git" ]] && linked_git_files+=("$worktree_path/.git")
  done
  (( ${#linked_git_files[@]} )) && append_setting "$WRITE_DENY_PATH" "${linked_git_files[@]}"
fi

# Claude Code loads settings, hooks, and skills from .claude, and hooks run outside the
# sandbox, so no session may write the .claude of its start directory or of any worktree
# of the repository. A deny on a path that does not exist may not be enforced, so the
# directory is created first; an empty directory does not show in git. A symlinked
# .claude is distrusted, so it is denied but never followed.
claude_dirs=("$PWD/.claude")
[[ -n "$worktree_root" ]] && claude_dirs+=("$worktree_root/.claude")
[[ -n "$main_worktree" ]] && claude_dirs+=("$main_worktree/.claude")
for worktree_path in "${repo_worktrees[@]}"; do
  claude_dirs+=("$worktree_path/.claude")
done
for claude_dir in "${claude_dirs[@]}"; do
  [[ -L "$claude_dir" ]] || mkdir -p "$claude_dir"
done
append_setting "$WRITE_DENY_PATH" "${claude_dirs[@]}"

if [[ -n "$main_worktree" ]]; then
  # Commits write the common git dir, which lies outside the working directory in
  # linked worktrees and when the session starts in a subdirectory. Hooks and config
  # run later outside the sandbox (git push is excluded), so they stay write-denied.
  append_setting "$WRITE_ALLOW_PATH" "$common_git_dir"
  append_setting "$WRITE_DENY_PATH" "$common_git_dir/hooks" "$common_git_dir/config"

  # git commit, fetch, and pull also run unsandboxed, so a hooks directory moved into
  # the working tree with core.hooksPath (husky, for example) stays write-denied too.
  hooks_path=$(git -C "$worktree_root" config --get core.hooksPath 2>/dev/null || true)
  if [[ -n "$hooks_path" ]]; then
    [[ "$hooks_path" == /* ]] || hooks_path="$worktree_root/$hooks_path"
    append_setting "$WRITE_DENY_PATH" "$hooks_path"
  fi
fi

if (( is_unsafe )); then
  update_settings '.sandbox.enabled = false'
  printf '%s\n' 'claude: unsafe mode — sandbox disabled for this session' >&2
fi

if [[ ${CLAUDE_LAUNCHER_PRINT_SETTINGS:-0} == 1 ]]; then
  printf '%s\n' "$settings_json"
  exit 0
fi

# Offer bypass mode in the Shift+Tab mode cycle without starting in it. An unsafe session
# has no sandbox, so it also gets no bypass mode: one of the two guards always stays.
bypass_args=()
(( is_unsafe )) || bypass_args=(--allow-dangerously-skip-permissions)
exec claude "${bypass_args[@]}" --settings "$settings_json" "${forwarded_args[@]}"
