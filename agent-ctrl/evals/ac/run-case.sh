#!/usr/bin/env bash
# Run one ac command eval case (its prompt.txt) against one sandboxed Claude home.
# Usage: run-case.sh <claude-home> <out-dir> <case> <repetition>
set -euo pipefail
readonly EVAL_DIR=$(cd "$(dirname "$0")" && pwd)
readonly RUN_TIMEOUT=2700
claude_home=$1 out_dir=$2 case_name=$3 repetition=$4
run_dir="$out_dir/$case_name-$repetition"

rm -rf "$run_dir" && mkdir -p "$run_dir/repo"
cp -r "$EVAL_DIR/project/." "$run_dir/repo/"
[ -d "$EVAL_DIR/cases/$case_name/overlay" ] && cp -r "$EVAL_DIR/cases/$case_name/overlay/." "$run_dir/repo/"
# Plans live outside .agents/ in the catalog so the repository's .agents ignore rule cannot drop them.
if [ -d "$EVAL_DIR/cases/$case_name/work" ]; then
  mkdir -p "$run_dir/repo/.agents/work" && cp -r "$EVAL_DIR/cases/$case_name/work/." "$run_dir/repo/.agents/work/"
fi
printf '.agents/\n__pycache__/\n' > "$run_dir/repo/.gitignore"
git -C "$run_dir/repo" init -q
git -C "$run_dir/repo" add -A
git -C "$run_dir/repo" -c user.name=eval -c user.email=eval@localhost commit -qm "seed"

cd "$run_dir/repo"
started_at=$(date +%s)
HOME=$claude_home timeout "$RUN_TIMEOUT" claude -p "$(cat "$EVAL_DIR/cases/$case_name/prompt.txt")" \
  --agent lead --model opus --output-format stream-json --verbose \
  --permission-mode acceptEdits --strict-mcp-config --settings '{"disableAllHooks": true}' \
  --allowedTools "Bash(python3:*)" "Bash(git status:*)" "Bash(git diff:*)" "Bash(git log:*)" \
  "Bash(ls:*)" "Bash(mkdir:*)" "Bash(date:*)" "Bash(sha256sum:*)" "Bash(cat:*)" "Bash(grep:*)" \
  > "$run_dir/transcript.jsonl" 2> "$run_dir/stderr.log" || echo "exit $?" > "$run_dir/exit-status"
echo $(($(date +%s) - started_at)) > "$run_dir/wall-seconds"
