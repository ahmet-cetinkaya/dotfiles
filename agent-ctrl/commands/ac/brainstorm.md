---
name: ac:brainstorm
description: Shape a rough idea into a concrete requirements brief through repository-grounded Socratic discovery, alternatives, constraints, and observable success criteria. Does not write a plan or implement.
---

# `/ac:brainstorm` — Shape an Idea

Turn an ambiguous idea into a concrete brief before researching a solution or planning implementation. The goal is not to produce lots of ideas; it is to discover the real need, expose the meaningful choices, and make success observable.

## Usage

```
/ac:brainstorm <topic or rough idea>
```

## Workflow

Activate `work-planning` for its repository-first discovery and question-filter discipline, but do **not** write a plan file. Route the dialogue through `planner`.

### 1. Ground the idea

Restate the idea and inspect the repository for relevant existing behavior, vocabulary, constraints, and ownership boundaries. Use `explorer` for broad internal discovery and `researcher` only when an external product or API fact materially affects the idea.

Do not ask the user questions the repository can answer.

### 2. Discover the need

Ask one focused question at a time. Prefer questions that change scope or direction:

- Who experiences the problem and in what situation?
- What is broken, costly, slow, confusing, or impossible today?
- What outcome matters, independently of a proposed implementation?
- What is explicitly out of scope?
- What compatibility, policy, time, or operational constraints apply?

Follow the answer rather than a fixed questionnaire. Challenge solution-shaped requests by asking what problem the proposed solution is meant to solve.

### 3. Compare alternatives

When several approaches are plausible, present 2–4 distinct alternatives with concrete benefits, costs, risks, and reversibility. Use `advisor` for genuine architecture or high-impact tradeoffs. Recommend one, but keep the owner-decision visible.

### 4. Make success observable

Translate the converged idea into testable outcomes. Include the golden path plus important boundary, failure, security, data-integrity, compatibility, and user-experience conditions when relevant.

## Output

```markdown
# Brainstorm Brief

## Problem and Goal
## Users and Use Cases
## In Scope / Out of Scope
## Constraints and Assumptions
## Alternatives Considered
## Recommended Direction
## Observable Success Criteria
## Open Owner-Decisions
## Recommended Next Step
```

## Next Step

Close the turn by naming the single best next command for the state you reached, as a
short line the user can act on:

- Solution or library choice still open → `/ac:research <question>`
- Direction settled, behavior should be approved before design → `/ac:spec <intent>`
- Direction settled, implementation non-trivial → `/ac:plan <request>`
- Direction settled and the change is small and known → `/ac:run <request>`
- Still ambiguous after discovery → state the blocking owner-decision and stop

Name exactly one recommendation. Never chain commands automatically.

## Boundaries

- Do not write `.agents/plans/`, edit code, install dependencies, commit, push, or create external resources.
- Do not manufacture product or business rules from code; record unsupported assumptions explicitly.
- Stop when the brief is actionable. More questions are not automatically better.
