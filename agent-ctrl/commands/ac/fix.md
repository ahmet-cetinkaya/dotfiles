---
name: ac:fix
description: Root-cause-driven bug, regression, failing-test, build-failure, and runtime-error fix flow. Diagnose first, reproduce when possible, apply the minimal repair, then verify.
---

# `/ac:fix` — Fix a Defect

Root-cause fix flow. Use this when behavior is broken: a bug, regression, failing test,
build failure, runtime error, or issue report. It diagnoses first, proves the failure
when possible, applies the smallest fix, then runs the verification gate.

## Usage

```
/ac:fix <issue | error | failing test | broken behavior>
/ac:fix <issue> --diagnose-only
/ac:fix <issue> --with-review
```

## Workflow

Activate `systematic-debugging` and route the workflow through `executor`. Use
`explorer` for code-path discovery, `researcher` only for external contracts, and one
`worker` for each scoped diagnosis or implementation task.

### 1. Triage

Classify the problem: bug, regression, failing test, runtime error, or build failure.

Route out of scope early:

- PR review comments → **`/ac:pr-address`**.
- New feature, component, API, or service → **`/ac:plan`** then **`/ac:run`**.
- Broad refactor, cleanup, or quality pass → **`/ac:review`** for findings, then a scoped
  plan or fix per finding.

### 2. Diagnose first

Do not patch symptoms.

- Trace from trigger → symptom → first observed invalid state.
- State the causal chain before changing code.
- If the chain has an uncertain link, test a concrete prediction.
- Ask the user only when investigation is genuinely blocked by missing information.

With `--diagnose-only`, stop after the diagnosis and recommended fix plan.

### 3. Reproduce

Prefer existing evidence over new scaffolding:

1. Run the existing failing test or reported reproduction path when available.
2. If no test captures the bug, identify the smallest regression test that should fail
   first.
3. Follow the project's existing test conventions before adding or changing tests.

### 4. Fix minimally

Apply one semantic fix for the confirmed root cause.

- Change only the files needed for the bug.
- Avoid drive-by refactors, formatting, cleanup, or speculative hardening.
- Sweep callers of the changed function and fix the shared owner once rather than
  patching each caller; patching only the reported path leaves sibling callers broken.
- Shortest diff wins only at the correct layer — a wrong-layer minimal patch is another
  bug.
- If a fix attempt fails, invalidate that hypothesis explicitly before trying another.

### 5. Escalate instead of thrashing

After two serious failed hypotheses, route the evidence and attempts to `advisor`.
After three materially different failed approaches, stop with a blocker report. Use an
independent advisor and the `secure-engineering` gate when the fix touches security,
auth, sensitive data, migrations, shared APIs, CI, or another high-risk boundary.

### 6. Verify

First verify the specific reproduction or regression test (red → green when practical).
Then activate `readiness-verification` for the affected scope. If verification reveals
a new hard-to-diagnose failure, loop back to diagnosis instead of stacking patches.

### 7. Optional targeted review

With `--with-review`, or when the fix touches risky logic, run `/ac:review` scoped to
the relevant lens (errors, types, security).

Use `clean-code` or `simplify` only as a separate follow-up when the fix exposes cleanup
work — never bundled into the fix itself.

### 8. Commit strategy (only when separately authorized)

Committing is not part of the fix flow; it requires its own authorization. When the user
does authorize it, apply the local-fixup policy from the `git-workflow` skill: if the
complete change belongs wholly to a related commit that is provably unpushed, stage only
the relevant files or hunks and use `git commit --fixup <sha>` instead of a noisy
standalone commit. Otherwise create a normal semantic commit. Never rewrite published
history without explicit authorization.

## Output

```text
Problem: <what was broken>
Root Cause: <causal chain with file:line references>
Evidence/Reproduction: <test, command, log, or repro path>
Fix Applied: <minimal change, or "diagnosis only">
Regression Test: <added/updated/existing test evidence>
Verification: <specific repro result + readiness verdict>
Confidence: <High|Medium|Low>
Follow-ups: <separate cleanup/review/product tasks, if any>
```

## Next Step

Close the turn by mapping the fix outcome to one command:

- Fix verified and scoped → `/ac:verify` for the full readiness gate
- Fix touches risky logic and had no independent pass → `/ac:review --area <lens>`
- Root cause found but the repair is large or architectural → `/ac:plan <request>`
- Still unresolved after three materially different approaches → report the blocker and stop

Name exactly one recommendation. Committing remains a separate, authorized step.

## Boundaries

- Do not apply code changes before the root cause is understood.
- Do not bundle broad refactors, redesign, or unrelated cleanup into the fix.
- Do not commit or push — that is a separate, explicitly authorized step.
- For feature work or PR comment handling, use planning/execution flows instead.
