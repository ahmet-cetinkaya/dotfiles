#!/usr/bin/env bash
# Run one /ac:fix eval case against one sandboxed Claude home.
# Usage: run-case.sh <claude-home> <out-dir> <case> <repetition>
set -euo pipefail
readonly EVAL_DIR=$(cd "$(dirname "$0")" && pwd)
readonly RUN_TIMEOUT=1500
claude_home=$1 out_dir=$2 case_name=$3 repetition=$4
run_dir="$out_dir/$case_name-$repetition"

rm -rf "$run_dir" && mkdir -p "$run_dir/repo"
cp -r "$EVAL_DIR/project/." "$run_dir/repo/"
cp -r "$EVAL_DIR/cases/$case_name/overlay/." "$run_dir/repo/"
printf '.agents/\n__pycache__/\n' > "$run_dir/repo/.gitignore"
git -C "$run_dir/repo" init -q
git -C "$run_dir/repo" add -A
git -C "$run_dir/repo" -c user.name=eval -c user.email=eval@localhost commit -qm "seed"

cd "$run_dir/repo"
HOME=$claude_home timeout "$RUN_TIMEOUT" claude -p "/ac:fix $(cat "$EVAL_DIR/cases/$case_name/report.txt")" \
  --agent lead --model opus --output-format stream-json --verbose \
  --permission-mode acceptEdits --strict-mcp-config --settings '{"disableAllHooks": true}' \
  --allowedTools "Bash(python3:*)" "Bash(git status:*)" "Bash(git diff:*)" "Bash(git log:*)" \
  "Bash(ls:*)" "Bash(mkdir:*)" "Bash(date:*)" "Bash(sha256sum:*)" "Bash(cat:*)" "Bash(grep:*)" \
  > "$run_dir/transcript.jsonl" 2> "$run_dir/stderr.log" || echo "exit $?" > "$run_dir/exit-status"
