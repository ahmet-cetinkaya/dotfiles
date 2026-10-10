---
name: ac:run
description: Execute an approved plan (or resume an in-progress one), or an already-clear scoped request, end to end through the executor with per-task verification and final gates.
---

# `/ac:run` — Execute a Plan or Scoped Request

Carries an approved plan through to completion with per-task verification. The plan is
the contract; execution does not redesign it. A request that is already clear runs the
same way without a plan file.

## Usage

```
/ac:run [plan-slug]        # omit to auto-select when exactly one plan is eligible
/ac:run <scoped request>   # implement an already-clear change without a plan file
```

## Workflow

Activate `plan-execution` and route the plan or request to `executor`.

### 1. Select and gate the input

An argument that names a plan under `.agents/plans/` is a plan; anything else is a
direct request.

**Plan.** If several are eligible and none was named, ask. Start only from
`status: approved`; resume `in_progress`, or `blocked` after its blocker is resolved.
Reject draft, completed, ambiguous, or still-blocked plans.

**Direct request.** Accept it only when the target files or area, the expected
behavior, and the acceptance conditions are already known or settled by the repository.
State those three before the first edit; they are the contract in place of a plan. Send
broken behavior to `/ac:fix`, and anything ambiguous, multi-step with open decisions, or
crossing a risk boundary to `/ac:plan` instead of guessing.

If the plan carries `spec:`, read that spec and move it `approved → in_progress` when
execution starts. The spec's requirements and preserved behavior are part of the
contract alongside the plan's tasks.

### 2. Execute task by task

Turn the plan's tasks into a dependency graph. One genuinely executing task is
`in_progress` at a time; parallelize independent tasks only when their write surfaces
do not conflict. The executor may coordinate only `worker`, `explorer`, `researcher`,
and `advisor`, following the acyclic graph — never `lead` or `planner`.

Each delegation carries the task goal verbatim, allowed files, inherited decisions,
acceptance criteria, required evidence, and exclusions.

### 3. Verify each result

The executor must inspect every changed file and verify child evidence before marking a
task `completed` — a worker's summary is not proof. Record checks as `PASS`, `FAIL`,
`BLOCKED`, or `NOT_APPLICABLE` with command, scope, and observable. Security, auth,
sensitive data, schema or migrations, shared APIs, CI, and critical user-facing changes
require independent `advisor` review.

### 4. Finish or stop honestly

Run the plan's final verification pass against the delivered state. If the plan is
wrong or a required decision is unresolved, report the blocker — do not substitute a
design. Update task states in the plan file as they change.

When implementation cannot follow a linked spec as written, do not change the
requirement silently: append the deviation and its reason to the spec's `## Deviations`
section, ask the user, and continue only with their decision. After final verification
passes, move the spec to `shipped`, merge its deltas into the living spec under
`specs/<capability>/SPEC.md`, and move the change directory under
`specs/changes/archive/`.

## Output

Per-task status with evidence, the final verification verdict, and any blockers or
follow-ups.

## Next Step

Close the turn by mapping the execution outcome to one command:

- All tasks complete, evidence green → `/ac:verify` for the independent readiness gate
- A gate failed or a defect surfaced → `/ac:fix <symptom>`
- The change crosses a risk boundary and needs an independent pass → `/ac:review`
- Blocked on a plan defect or owner-decision → state the blocker and stop

After a clean verify, the delivery path is `/ac:pr`. Never commit, push, or open a PR
without explicit authorization.

## Boundaries

- Do not start from a draft plan or silently redesign an approved one.
- Do not run a direct request whose scope or acceptance conditions are unclear; route it
  to `/ac:plan`.
- Do not rewrite a spec's requirements to match the code; record deviations and ask.
- Do not commit, push, open a PR, merge, deploy, or alter shared state without explicit
  authorization.
