# Acceptance Criteria

Write criteria as observable outcomes rather than implementation wishes.

Each criterion should identify:

- the starting state or input;
- the behavior or invariant being exercised;
- the binary observable that decides success;
- the evidence source: test, diagnostic, build, inspection, sandbox run, or real-surface QA;
- relevant negative, boundary, failure, compatibility, or recovery behavior.

Add risk-specific criteria only when applicable. Security or auth work should prove trust-boundary behavior; data or migration work should name integrity and rollback checks; shared APIs should cover affected callers; user-facing work should include hands-on QA on the actual surface.

Avoid vague words such as “works,” “robust,” or “secure” without an observable. Follow the project's own coverage target and conventions; do not invent a global percentage, mandatory language pattern, or fixed file-size rule.
