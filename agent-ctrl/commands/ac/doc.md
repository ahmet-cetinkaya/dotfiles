---
name: ac:doc
description: Create or update focused documentation for a function, module, API, feature, or operational flow from verified repository behavior and the project's existing documentation style.
---

# `/ac:doc` — Focused Documentation

Create documentation that is accurate for the current implementation, useful to a named audience, and placed where the repository already expects it.

## Usage

```
/ac:doc <target> [--audience user|developer|operator] [--type inline|reference|guide|architecture]
```

If the user asks to “explain” or “draft,” return documentation in chat. If the user asks to “write,” “add,” or “update,” file edits are authorized within the resolved documentation scope.

## Workflow

Activate `technical-writing`.

### 1. Resolve target and audience

Identify the exact function, module, API, feature, or flow; its intended reader; and the required form:

- **inline** — short why-comment or docstring for a non-obvious invariant or public contract;
- **reference** — signatures, inputs, outputs, errors, examples, compatibility;
- **guide** — task-oriented steps, prerequisites, verification, troubleshooting;
- **architecture** — responsibilities, boundaries, control/data flow, tradeoffs.

### 2. Establish repository truth

Use `explorer` to read the implementation, public interfaces, immediate callers, tests, configuration, and existing docs. Follow cross-references far enough to verify behavior and failure paths. Do not document names, guarantees, examples, or commands that were not verified.

### 3. Match local style and placement

Find neighboring docs, heading conventions, terminology, link style, generated-doc markers, and ownership. Prefer updating the canonical existing document over creating a parallel one. Never hand-edit generated, vendored, or external documentation. Write to the `technical-writing` skill: local style first, Simplified Technical English where the repository has none.

### 4. Write only when authorized

For requested edits, delegate the bounded change to `worker`. Explain behavior at the reader's level, distinguish guarantees from examples, include error/failure behavior, and use runnable examples where the repository supports them. Public API, security, migration, or operational runbook changes receive an independent `advisor` review.

### 5. Verify

Check links, commands, code samples, formatting/lint rules, and consistency with the implementation. If a documentation toolchain exists, run its focused validation. Inspect the final diff for accidental behavior claims or unrelated rewrites.

## Output

State the documented target and audience, changed files or chat draft, verified sources, validation run, and any behavior that could not be confirmed.

## Next Step

Close the turn by naming what follows the documentation, when anything does:

- Docs are part of a release → `/ac:changelog [range]`
- Docs revealed a behavior defect → `/ac:fix <symptom>`
- Docs are ready to ship with the branch → `/ac:verify`, then `/ac:pr`
- Nothing follows → say the documentation is complete and stop

Name at most one recommendation. Publishing remains a separate, authorized step.

## Boundaries

- Comments explain **why**, hidden constraints, and surprising behavior — not what clear code already says.
- Do not invent future behavior, duplicate canonical docs, or change product code merely to make the docs easier to write.
- Do not publish docs, commit, or push without separate authorization.
