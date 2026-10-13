---
name: ac:verify
description: Evidence-based readiness verification of the current state — build, tests, lint, types, and behavior checks with PASS/FAIL/BLOCKED verdicts per gate.
---

# `/ac:verify` — Verify Readiness

Answers one question with evidence: is the current state actually done and safe to hand off? Runs the project's real gates and reports observable results — a summary is not proof.

## Usage

```
/ac:verify                 # verify the current working state
/ac:verify <scope>         # verify a specific feature, path, or plan's outcome
```

## Order of Operations

1. **Reflection first** — validate the _task_ was actually accomplished. When a spec is linked (via the plan's `spec:` or the scope argument), reflection means a criterion ↔ evidence table: one row per `FR-###`, `SC-###`, and `PB-<n>` with the action or check that proves it. A criterion without evidence is an unmet requirement.
2. **Mechanical gate last** — confirm the code is _correct_ (build → type → lint → test → security → diff).

Run reflection before the toolchain: there is no point burning build/test cycles on work that does not satisfy the requirements. Reflection also scopes what "correct" even means for this task.

If reflection flags unmet requirements or scope drift, the verdict is **NOT_READY** — stop and address those gaps before spending cycles on the mechanical gate. Even a fully green gate stays `NOT_READY` when reflection found unmet requirements.

## Workflow

Activate `readiness-verification` and route execution to `executor` with read-only inspection by `advisor` where independence is required.

### 1. Discover the project's own gates

Use the commands the repository defines (package scripts, Makefile, CI config) — do not substitute generic equivalents when project-specific ones exist.

**Stack detection and profile delegation.** Detect the stack and defer to the active project's profile verification skill for the exact build/type/lint/test commands — this command stays stack-agnostic and never hard-codes per-language toolchains. If no profile matches, infer the toolchain from the project manifest (`package.json` scripts, `pyproject.toml`, `Makefile`, `go.mod`, `Cargo.toml` targets) and run the equivalent commands rather than skipping the phase. A gate you chose not to run is `BLOCKED`, not `NOT_APPLICABLE`.

### 2. Run each applicable gate

Typical gates, in order of cost: format/lint, type check, unit tests, build, integration/e2e where present, and a targeted behavioral check of the changed feature. Record each as:

- `PASS` — command, scope, and the observable that proves it
- `FAIL` — exact failure output and the affected surface
- `BLOCKED` — what prevents the check from running
- `NOT_APPLICABLE` — why the gate does not apply

### 3. Behavior over green checkmarks

Type checks and tests verify code correctness, not feature correctness. When the change is user-facing, exercise the actual behavior path; if that is impossible, state so explicitly rather than implying coverage.

## Output

```text
Verdict: READY | NOT_READY | INCONCLUSIVE
Criteria (when a spec is linked):
  <FR-###|SC-###|PB-n>: PASS|FAIL|BLOCKED — <action or check + observable>
Drift: <behavior found in code that no requirement asks for, or spec text the code contradicts>
Gates:
  <gate>: PASS|FAIL|BLOCKED|NOT_APPLICABLE — <command + observable>
Failures: <exact output for each FAIL>
Gaps: <checks that could not run and why>
```

## Next Step

Close the turn by mapping the verdict to one command:

- `READY` and the branch is for delivery → `/ac:pr [base]`
- `READY` and the work needs an independent pass first → `/ac:review`
- `NOT_READY` → `/ac:fix <failing gate>`
- `NOT_READY` because the spec itself is wrong or drifted → `/ac:spec <spec-path>` to record the change, then re-plan
- `INCONCLUSIVE` → name the blocked gate and what would unblock it, then stop

Name exactly one recommendation. Never fix failures inside this command.

## Boundaries

- Verification only — do not fix failures here; route them to `/ac:fix`.
- Never report `READY` with a failing or skipped required gate, or with a spec criterion lacking evidence.
- Do not weaken, skip, or mark tests as expected-failure to force a green result.
