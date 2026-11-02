#!/usr/bin/env bash
# Launch Claude Code inside its Bash sandbox with per-repository grants.
# The sandbox policy lives in settings.json; this launcher adds what depends on the
# repository: symlink grants from <main-worktree>/.claude/additional-dirs.local,
# audited widenings from <main-worktree>/.claude/claude-launcher.local.json
# (allowDotnetState, allowedDomains), git access from linked worktrees, and a
# write deny on <main-worktree>/.claude so a session cannot widen the next one.
# `claude --lite` starts one session with the sandbox off, as a rollback.
set -u

readonly DOMAIN_PATTERN='^(\*\.)?[a-z0-9-]+(\.[a-z0-9-]+)+(:[0-9]+)?$'
readonly WRITE_DENY_PATH='["sandbox","filesystem","denyWrite"]'
readonly WRITE_ALLOW_PATH='["sandbox","filesystem","allowWrite"]'
readonly DOMAIN_ALLOW_PATH='["sandbox","network","allowedDomains"]'

is_lite=0
forwarded_args=()
for arg in "$@"; do
  if [[ "$arg" == --lite ]]; then
    is_lite=1
  else
    forwarded_args+=("$arg")
  fi
done

# Append values to the array at a JSON path in settings_json, keeping it unique.
append_setting() {
  local json_path=$1
  shift
  settings_json=$(jq -c --argjson path "$json_path" --args \
    'setpath($path; ((getpath($path) // []) + $ARGS.positional | unique))' \
    "$@" <<<"$settings_json")
}

# A tracked file or a symlinked .claude is repository-controlled, so it cannot widen access.
is_local_trust_file() {
  local relative_path=$1
  [[ -f "$main_worktree/$relative_path" && ! -L "$main_worktree/.claude" ]] &&
    ! git -C "$main_worktree" ls-files --error-unmatch -- "$relative_path" >/dev/null 2>&1
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
export BUN_TMPDIR="${BUN_TMPDIR:-$sandbox_tmp}"

settings_json='{"sandbox":{"allowUnsandboxedCommands":true}}'
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
  settings_json=$(jq -c --args \
    '.permissions.additionalDirectories = ((.permissions.additionalDirectories // []) + ($ARGS.positional | unique))' \
    "${additional_dirs[@]}" <<<"$settings_json")
fi

if [[ -n "$main_worktree" ]]; then
  # A deny on a path that does not exist may not be enforced, so create the
  # directory first; an empty directory does not show in git. A symlinked .claude
  # is distrusted, so it is denied but never followed.
  [[ -L "$main_worktree/.claude" ]] || mkdir -p "$main_worktree/.claude"
  append_setting "$WRITE_DENY_PATH" "$main_worktree/.claude"

  if [[ "$worktree_root" != "$main_worktree" ]]; then
    # Linked worktrees commit into the common git dir. Hooks and config run later
    # outside the sandbox (git push is excluded), so they stay write-denied.
    append_setting "$WRITE_ALLOW_PATH" "$common_git_dir"
    append_setting "$WRITE_DENY_PATH" "$common_git_dir/hooks" "$common_git_dir/config"
  fi

  policy=.claude/claude-launcher.local.json
  if is_local_trust_file "$policy"; then
    if [[ $(jq -r '.allowDotnetState // false' "$main_worktree/$policy" 2>/dev/null) == true ]]; then
      # `dotnet run file.cs` keeps its virtual project in runfile, named mutexes use
      # /tmp/.dotnet/shm, and a cold restore writes the package caches.
      append_setting "$WRITE_ALLOW_PATH" "$HOME/.local/share/dotnet/runfile" "/tmp/.dotnet/shm" \
        "$HOME/.nuget/packages" "$HOME/.local/share/NuGet" "$HOME/.dotnet"
    fi

    mapfile -t policy_domains < <(jq -r \
      '.allowedDomains // [] | if type == "array" then .[] | strings else empty end' \
      "$main_worktree/$policy" 2>/dev/null)
    valid_domains=()
    for domain in "${policy_domains[@]}"; do
      if [[ "$domain" =~ $DOMAIN_PATTERN ]]; then
        valid_domains+=("$domain")
      else
        printf 'claude: ignoring invalid allowedDomains entry: %s\n' "$domain" >&2
      fi
    done
    (( ${#valid_domains[@]} )) && append_setting "$DOMAIN_ALLOW_PATH" "${valid_domains[@]}"
  fi
fi

if (( is_lite )); then
  settings_json=$(jq -c '.sandbox.enabled = false' <<<"$settings_json")
  printf '%s\n' 'claude: lite mode — sandbox disabled for this session' >&2
fi

if [[ ${CLAUDE_LAUNCHER_PRINT_SETTINGS:-0} == 1 ]]; then
  printf '%s\n' "$settings_json"
  exit 0
fi

# Offer bypass mode in the Shift+Tab mode cycle without starting in it.
exec claude --allow-dangerously-skip-permissions --settings "$settings_json" "${forwarded_args[@]}"
