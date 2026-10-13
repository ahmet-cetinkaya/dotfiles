# Run State

Runtime state makes a plan run resumable after compaction or a new session and keeps an audit trail of what was proven. The plan file stays the source of truth for status and task states; the state directory holds only what the plan does not.

## Layout

```text
.agents/state/<slug>/
├── state.json      # resume pointer and review receipts
├── notepad.md      # append-only learnings handed to later tasks
├── ledger.jsonl    # one event per line
└── evidence/       # captured artifacts and evidence records
```

`<slug>` is the plan slug. Work without a plan file (a direct request, `/ac:fix`, or a plan-less `/ac:verify`) uses `<YYYYMMDD>-<scope-slug>`.

Only the orchestrating agent writes state: the executor during a run, the main session during a plan review or a verification. Workers never write it; they return findings and evidence, and the orchestrator records them. This keeps parallel workers from conflicting on shared files.

Runtime state is local and never committed. Before the first write, check `git check-ignore -q .agents/state/`; when it is not ignored, say so once and recommend adding `.agents/state/` to `.gitignore`. Do not edit `.gitignore` unasked.

## `state.json`

```json
{
  "plan": ".agents/plans/<slug>.md",
  "started_at": "<ISO-8601>",
  "updated_at": "<ISO-8601>",
  "active_tasks": ["<task id>"],
  "review": {
    "round": 1,
    "plan_sha256": "<sha256 of the reviewed plan bytes>",
    "lanes": {
      "executability": { "verdict": "<verdict>", "at": "<ISO-8601>" },
      "adversarial": { "verdict": "<verdict>", "at": "<ISO-8601>" }
    }
  }
}
```

On start, an existing `state.json` for an `in_progress` or resolved `blocked` plan is a resume: read it, the plan's task states, the notepad, and the ledger tail, then continue from the first unfinished task. Never replay completed tasks. When state and plan disagree, the plan wins and the disagreement is recorded as a ledger event.

## `notepad.md`

Append-only; never rewrite earlier entries. Each entry is headed `## <ISO-8601> Task <id>` and filed under one of: Learnings (conventions, patterns), Decisions (choices made during execution), Issues (gotchas and workarounds), Problems (unresolved blockers). Read it once before each batch and pass the relevant entries to workers as inherited context.

## `ledger.jsonl`

One JSON object per line, appended as events happen:

```text
{"at": "<ISO-8601>", "event": "check", "task": "3", "check": "unit tests", "status": "PASS", "command": "<exact command>", "observable": "<what proved it>", "artifact": "evidence/<file>"}
```

Events: `run_started`, `run_resumed`, `task_started`, `check`, `task_completed`, `task_blocked`, `review`, `final_verification`, `run_completed`. Statuses follow the evidence contract. A task is `completed` in the plan only after its `task_completed` event cites passing checks; under a commit strategy that event also carries `commit` (hash) and `message`.

## Evidence records

Capture real output — command logs, HTTP responses, screenshots, data readbacks — under `evidence/`. A verification writes `evidence/<ISO-8601-date>-verify.md` with one section per gate or criterion:

- **Tested** — the exact command or action and the surface it drove.
- **Observed** — the actual observable and the artifact path holding the raw output.
- **Why enough** — how this covers the intended behavior and what regression risk remains.
- **Omitted** — anything redacted or summarized.

Never store secrets: redact tokens, credentials, auth headers, private keys, and secret-bearing environment dumps before writing, and summarize instead of copying when redaction is not reliable. An evidence record describes checks that ran; it never stands in for one that did not.
