#!/usr/bin/env bash
# Launch Claude Code with per-repository symlink grants and tool temp paths.
# Each non-comment line in <main-worktree>/.claude/additional-dirs.local names a
# symlinked directory relative to the current worktree root.
# LITE MODE: all sandbox/permission hardening is removed for now (see
# .local/backups/pre-sandbox-removal-20261005/ for the hardened baseline). Only
# symlink grants, BUN/.NET temp paths and the notify hooks remain.
set -u

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

if [[ ${CLAUDE_LAUNCHER_PRINT_SETTINGS:-0} == 1 ]]; then
  printf '%s\n' "$settings_json"
  exit 0
fi

exec claude --settings "$settings_json" "$@"
