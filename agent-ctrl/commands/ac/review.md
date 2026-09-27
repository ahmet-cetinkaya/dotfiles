---
name: ac:review
description: "Central code-review hub. With no area argument, asks (multi-select) which review areas to run, then applies the matching review lenses and consolidates one severity-ordered report."
---

# `/ac:review` — Central Code Review Hub

This command is the **single entry point** for all code review. It does not review code itself — it selects a **target**, resolves which **review areas** to run, applies the matching lenses from the `risk-review` skill, and consolidates their output into one report.

Read-only: findings are reported, never auto-fixed.

## Usage

```bash
/ac:review [target] [--area <area1> <area2> ...]
```

### Target

- **`pr`**: review the changes on the active Pull Request.
- **`git`**: review uncommitted/staged/untracked `git diff` changes (default).
- **`[path]`**: review files under a path (e.g., `.`, `src/auth`).
- If no target is given → default to `git` changes; if there are none → target `.`.

## Review Areas

Each area is a lens defined in [`risk-review`](../../skills/risk-review/SKILL.md); load only the selected ones.

| Area | Focus | Partitioned? |
|---|---|---|
| **correctness** | Logic errors, edge cases, broken invariants, concurrency, regressions | — (always active) |
| **clean-code** | Readability, naming, structure, duplication | ✅ 8 aspects |
| **security** | Trust boundaries, authn/authz, injection, secrets, sensitive data | — |
| **performance** | Demonstrated hot paths, algorithmic growth, queries, allocations, contention | — |
| **architecture** | Ownership, coupling, public contracts, layering, reversibility | — |
| **errors** | Propagation, recovery, partial state, observability, user-safe messages | — |
| **types** | Contract accuracy, unsafe assertions, nullability, serialization | — |
| **simplify** | Complexity and over-engineering: delete/stdlib/native/yagni/duplicate/shrink | — |
| **tests** | Suite effectiveness: correctness, false positives, missing edge/error cases, flakiness risk, meaningful coverage | — |

## Flow

### 1. Resolve target

Collect the files in scope from the target (PR / git diff / path), per the rules above. Include untracked files when reviewing working-tree changes — new files are where defects hide.

### 2. Resolve areas

- **If `--area` is passed:** use those areas directly — do **not** ask.
- **If no area is passed:** ask with a **multi-select** question, listing the areas above with their one-line descriptions. The user picks any subset (selecting all = full review).

**Ask through the runtime's own question tool, not through chat text.** Use the native interactive prompt the agent runtime provides (in Claude Code: `AskUserQuestion` with `multiSelect: true`), so the areas render as selectable options rather than a list the user has to retype. One option per review area, each carrying its one-line description as the option label/description. Only fall back to a plain numbered list in chat when the runtime exposes no interactive question tool.
- **Correctness is always included**, whether or not it was selected.
- When the diff crosses a risk boundary (auth, persistent or sensitive data, schema or migration, shared API, CI), add `security` and route an independent pass to `advisor` even if it was not selected. State that you did so.

### 3. Resolve clean-code aspects (only if `clean-code` was selected)

`clean-code` is partitioned into eight aspects. Ask a **second** multi-select question through the same interactive question tool — one option per aspect, never a plain chat list:

`comments (C1-C5)`, `environments (E1-E2)`, `functions (F1-F4)`, `naming (N1-N7)`, `architecture (G1-G10)`, `hygiene (G11-G20)`, `logic (G21-G36)`, `tests (T1-T9)`.

Clean-code `tests (T1-T9)` means test-code cleanliness (naming, structure, duplication, readability). Top-level `tests` means suite effectiveness (whether tests catch real bugs). Selecting both is valid and non-redundant.

If `--area clean-code` was passed without an explicit aspect list, default to all eight.

### 4. Apply the lenses

For each selected area, apply its lens to the target files. Run independent areas in parallel where possible. Use `explorer` to establish surrounding context — callers, contracts, and tests — so findings rest on how the code is actually used rather than on the diff in isolation.

Reviewers may use **`serena`** for symbol-level navigation and **`codegraph`** for call paths and blast-radius analysis on the changed symbols. For the top-level `tests` area, include production code plus its corresponding tests in context and review from a risk-based testing perspective.

### 5. Consolidate

Compile every lens's findings into a single, structured **Code Review Report**, grouped by area with the highest-severity findings first.

## Finding discipline

Report only findings satisfying the [finding contract](../../skills/risk-review/references/finding-contract.md) — every one needs a stable `file:line` pointer, severity and impact, a concrete failure scenario, reproduction or evidence, and a remedy at the owning layer. Suspicions without evidence belong under "Evidence gaps", never as findings.

## Output

```text
Verdict: <approve | approve-with-nits | request-changes>
Confidence: <HIGH | MEDIUM | LOW>
Areas reviewed: <list, noting any auto-added by risk>

Findings (by severity):
  [CRITICAL|MAJOR|MINOR|NITPICK] <area> file:line
    Issue / scenario / evidence / remedy

Evidence gaps: <what could not be verified and why>
```

## Apply Findings

`/ac:review` reports findings; to act on them, hand off:

- **`/ac:fix`** — repair a defect the review surfaced, root-cause first.
- **`/ac:plan`** — plan a larger refactor or architectural change the findings justify.
- **`/ac:verify`** — run the readiness gate when findings need runtime evidence or post-fix confirmation.

## Next Step

Close the turn by mapping the verdict to one command:

- `request-changes` with a concrete defect → `/ac:fix <finding>`
- `request-changes` needing a larger refactor → `/ac:plan <request>`
- `approve-with-nits` → name the optional follow-ups and let the user choose
- `approve` on a branch ready to ship → `/ac:verify`, then `/ac:pr`
- Findings need runtime evidence → `/ac:verify`

Name exactly one primary recommendation. Never apply fixes from this command.

## Boundaries

- This command **only** orchestrates and reports. It does not modify files.
- Never skip the area question when no `--area` is supplied — area selection is the point of the hub.
- Do not apply a lens (or a clean-code aspect) that was not selected, except the always-on correctness lens and risk-triggered security escalation.
- Do not soften severity to avoid friction, or invent findings to appear thorough. Security, auth, and data-handling findings are never downgraded without evidence.
