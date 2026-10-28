#!/usr/bin/env bash
# Run every case <repetitions> times against each sandboxed Claude home, four runs at a time.
# Usage: run-all.sh <out-root> <repetitions> <claude-home>...
set -euo pipefail
readonly EVAL_DIR=$(cd "$(dirname "$0")" && pwd)
readonly PARALLEL_RUNS=4
out_root=$1 repetitions=$2
shift 2
for claude_home in "$@"; do
  for case_dir in "$EVAL_DIR"/cases/*/; do
    for repetition in $(seq 1 "$repetitions"); do
      printf '%s\0%s\0%s\0%s\0' "$claude_home" "$out_root/$(basename "$claude_home")" "$(basename "$case_dir")" "$repetition"
    done
  done
done | xargs -0 -n 4 -P "$PARALLEL_RUNS" "$EVAL_DIR/run-case.sh"
