---
name: ac:spec
description: Write or refine one behavior spec (what and why, never how) under specs/changes before any plan. Re-running on an existing spec asks targeted clarifying questions. Only explicit approval makes a spec plannable.
---

# `/ac:spec` — Specify Behavior

Captures the intended behavior of one change as a testable spec that the user approves
before design begins. The spec is the contract for `/ac:plan`; no product code, no plan,
and no technology decisions are written here.

## Usage

```
/ac:spec <intent>                 # new change: write specs/changes/<NNNN>-<slug>/SPEC.md
/ac:spec <spec-path>              # existing draft: clarify and refine it in place
/ac:spec <intent> --capability <name>   # target an existing living spec as a delta
```

## Workflow

Activate `work-planning` in **Spec First** mode and `technical-writing` for the spec prose, and route the request to `planner`.

### 1. Repository before questions

Read the project's instruction files and any living spec under `specs/` for the
affected capability. Delegate discovery of current behavior, vocabulary, and constraints
to `explorer`; use `researcher` only when an external product or API fact materially
shapes the requirements. An existing convention beats a question every time.

### 2. Settle the direction before writing

Write no file until the direction is clear. When the intent arrives as a solution
("add X"), ask what problem it solves and for whom, and restate it as the outcome that
matters. When several product directions are plausible, present two to four distinct
alternatives with benefits, costs, risks, and reversibility, recommend one, and let the
user choose; use `advisor` for a genuine high-impact tradeoff. Ask one focused question
at a time and stop as soon as the intent can be specified. If the idea does not survive
this step, say so and create nothing.

### 3. Write the change spec

Create `specs/changes/<NNNN>-<slug>/SPEC.md` following the spec contract: intent,
prioritized user stories with Given/When/Then scenarios, `FR-###` requirements in EARS
form, measurable `SC-###` success criteria, edge cases, assumptions, and out-of-scope
boundaries. `<NNNN>` is the next unused number across `specs/changes/` and its
archive; `<slug>` is two to four kebab-case words.

When the change alters an existing capability, write the requirements as `ADDED`,
`MODIFIED`, and `REMOVED` deltas against the living spec and add at least two
`PRESERVED` statements naming behavior that must keep working.

Adopt defensible defaults and record them under Assumptions. Mark only what a default
cannot settle with `[NEEDS CLARIFICATION: …]`, at most three.

### 4. Self-check

Run the requirements checklist and the hostile-reader pass from the spec quality
reference, fixing findings in place for at most three rounds. Then ask the surviving
questions — all in one message, each with a recommended option — and fold the answers
into the spec.

### 5. Refine an existing spec

When given a spec path, rate the coverage taxonomy, ask at most five questions one at a
time for `Partial` or `Missing` areas, each with a recommended answer. Write each answer
into the affected section immediately, log it under `## Clarifications` as
`- Q: … → A: …` for the session date, and remove any marker it resolves.

### 6. Leave it as a draft

The spec keeps `status: draft`. Say plainly that only explicit user approval changes it
to `approved`, and that approval covers the intent, not the risky operations a later
plan may propose.

## Output

The spec path, the user stories with their priorities, the count of requirements and
success criteria, adopted assumptions, and any open `[NEEDS CLARIFICATION]` markers.

## Next Step

Close the turn with the spec path and the recommended next command:

- Markers or `Partial` areas remain → answer them, or `/ac:spec <spec-path>` to refine
- Spec is complete and you agree with it → approve it, then `/ac:plan <spec-path>`
- A solution or library choice blocks the intent → `/ac:research <question>` first
- The direction could not be settled → state the blocking owner-decision and stop

Name exactly one recommendation. Never chain commands automatically.

## Boundaries

- Do not write product code, a plan, or technology choices; the plan owns the how.
- Do not edit a spec under `specs/changes/archive/` or a living spec under
  `specs/`; new behavior is a new change.
- Do not approve the spec or move it past `draft`; only the user does.
- Do not commit or push.
