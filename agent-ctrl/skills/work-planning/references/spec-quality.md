# Spec Quality

Run these passes before presenting a spec. Fix findings in place, at most three rounds; carry anything still open as a `[NEEDS CLARIFICATION]` marker or an Assumption.

## Clarification filter

Apply [the question filter](question-filter.md) first: repository evidence and defensible defaults answer most questions. What survives is prioritized:

1. **Scope** — what is in or out, which user stories exist, what the P1 slice is.
2. **Security and privacy** — who may do what, which data is sensitive, what must be audited.
3. **User experience** — visible behavior on success, failure, and empty states.
4. **Technical constraints the user owns** — compatibility, external systems, data shape.

When creating a spec, ask at most three surviving questions, all in one message, each as a short option list with a recommended choice. When refining an existing spec, ask at most five, one at a time, each with a recommended answer; write the answer into the affected section immediately and log it under Clarifications.

## Coverage taxonomy

Rate each area `Clear`, `Partial`, or `Missing` when reviewing an existing spec; only `Partial` or `Missing` areas may produce questions.

- Functional scope and success signal
- Actors, roles, and permissions
- Data shape, lifecycle, retention, and volume
- Interactions and visible states
- Non-functional constraints: performance, reliability, accessibility, observability
- Integrations and external dependencies
- Edge cases and failure handling
- Terminology consistency
- Out-of-scope boundaries
- Preserved behavior (for changes to existing capabilities)

## Requirements checklist

- [ ] No implementation detail: no language, framework, storage, or file names.
- [ ] Every `FR-###` uses an EARS pattern with `SHALL` and one observable behavior.
- [ ] Every `FR-###` traces to a user story; every story has at least one scenario.
- [ ] Every `SC-###` is measurable and technology-agnostic.
- [ ] Edge cases cover empty, invalid, boundary, unauthorized, and failure inputs.
- [ ] Changes to existing behavior include `PRESERVED` statements (at least two).
- [ ] Assumptions are listed; no silent guess remains in the requirement text.
- [ ] At most three `[NEEDS CLARIFICATION]` markers; none inside an approved spec.
- [ ] No vague words (“works,” “fast,” “secure,” “robust”) without an observable.
- [ ] Terminology is consistent across stories, requirements, and criteria.
- [ ] Sections that do not apply are removed, not left as “N/A.”

## Hostile-reader pass

Read the spec as someone who wants to implement it wrongly while still satisfying the text. For each requirement ask: could two reasonable engineers build different things from this sentence? Which input or state is not covered? What would a careless or malicious user try? Every gap found becomes a sharper requirement, an edge case, or an Assumption — never a comment.
