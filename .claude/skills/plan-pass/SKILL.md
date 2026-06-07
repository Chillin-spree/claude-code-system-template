---
name: plan-pass
description: Use when a NAMED feature is too large for one pass (more than ~5–7 requirements) and needs breaking into passes before any implementation. Writes a Pass Plan into the feature file; makes no edits. Not for executing a pass, not for small features.
---

# Plan a pass

For a named feature with more than ~5–7 meaningful requirements, break it into small reviewable
passes before any code is touched. This skill **plans only — it makes no code edits.** Executing
a pass is `implement-pass`; a small feature needs no plan — go straight to `implement-pass`.

## Steps

1. Confirm or create `docs/features/<feature>.md` and note it in `docs/STATUS.md` as the active feature.
2. Write a **Pass Plan** into that feature file:
   - **Goal** — one sentence.
   - **Scope** / **Out of scope** — bullet the included and excluded outcomes.
   - **Pass breakdown** — ordered passes, each one focused outcome. Start with investigation-only when the area is unknown or risk is High; end with QA + docs.
   - **Expected files** — the files each pass will likely touch.
   - **Risks** — and their mitigations.
   - **Acceptance / QA** — observable completion criteria; for UI, "exercised in a browser".
3. Keep only the current plan in the feature file; don't pre-write detailed prose for far-off passes.

## Report

- The pass breakdown (numbered).
- Which pass is first and why it's safe to start there.

End with a **Next prompt** block: a paste-ready prompt to run the first pass (via `implement-pass`).
