# `technical-writing` composition

- **Target and responsibility:** One prose discipline for every human-readable deliverable: verified content, named reader, repository style first, Simplified Technical English as the default.
- **Sources:** `agent-ctrl.old/commands/ac/doc.md` and `agents/technical-writer.md`, audience targeting and verified-behavior rule; [ASD-STE100](https://www.asd-ste100.org/) Simplified Technical English, sentence and paragraph limits, one instruction per sentence, active voice, one term per concept, warnings before steps.
- **Behavior taken:** Reader-level writing, no unverified claims, local style precedence, STE sentence/word/structure rules, technical names kept verbatim, final read-as-reader pass.
- **Merge:** The style block previously inside `/ac:doc` becomes a skill so `/ac:doc`, `/ac:changelog`, `/ac:pr`, `/ac:spec`, and direct README or report writing share it by name.
- **Provider adaptation:** Pure prose rules; no provider tooling, linter, or dictionary lookup assumed.
- **Exclusions:** The STE approved-word dictionary (licensed, not bundled), word-by-word enforcement, non-English text, and code comments were excluded.
- **Attribution:** Original synthesis from the local legacy catalog and the publicly documented ASD-STE100 specification.
