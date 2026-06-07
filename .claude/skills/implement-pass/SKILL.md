---
name: implement-pass
description: Use to build, add, or change an ALREADY-DECIDED feature or behavior in one focused pass — "add X", "implement Y", "build the Z". Not for net-new visual design with no decided direction (design-bridge), not for fixing broken behavior (bug-hunt), not for features too large for one pass (plan-pass first).
---

# Implement a pass

Scope and execute **one** focused outcome for an already-decided feature. Smallest safe change.

**Not this skill when:** the visual direction isn't decided (→ `design-bridge`); existing
behavior is broken (→ `bug-hunt`); the feature is too large for one pass (→ `plan-pass` first).

## Steps

1. **Scope** — state the single outcome for this pass and what's explicitly not in it. Read the active feature file if one exists.
2. **Build** — the smallest change that delivers the outcome. Follow existing patterns. Don't add dependencies, frameworks, or a build step; if the task seems to need one, stop and ask. For UI work the `web-app` conventions apply; if the design direction isn't decided, stop and use `design-bridge`.
3. **Verify** —
   - Run relevant checks: `npm run lint` and `node --test` (skip with a stated reason only if there's nothing to run).
   - For any UI change, **open it in a browser and exercise it** before claiming done.
   - For a larger or higher-risk change, run the `reviewer` agent over the diff against the feature plan.
4. **Record** — update `docs/STATUS.md` (and the feature file's Passes/Acceptance) if state changed.

## Guardrails

- Stay in the active task; don't touch unrelated files.
- Never commit or push (that's `ship`, and only when asked).
- High-risk areas (auth, secrets, data, CI) → plan before editing.

## Report

Summary · Files changed · Checks run (and result) · Anything blocked/risky.

End with a **Next prompt** block: the most likely next step (next pass, QA, review, or `ship`).
