---
name: kickoff
description: Use ONLY for session orientation when no specific task is named yet — returning to the project, "where were we", "what's next", getting oriented. Does not build, fix, design, plan a specific feature, or configure the stack (stack-setup).
---

# Kickoff

Orient before any work: read state, report it, then wait for direction. This skill is **only**
for orientation — the moment a specific task is named, hand off to the workflow that owns it.

## Steps

1. Read `docs/STATUS.md` — the current Workflow State.
2. If STATUS lists an active feature file, read it (`docs/features/<feature>.md`).
3. Read `docs/DECISIONS.md` / `docs/BUGS.md` **only** if STATUS or the feature points at something relevant.

## Report

Keep it to a short brief:

- **Where we are** — mode, active feature, risk.
- **Next step** — the recommended next action from STATUS (or the obvious one if STATUS is stale).
- **Blockers** — anything waiting on the user.

Do not build, fix, design, or plan a specific feature from kickoff. If the user says to
proceed, hand off to the right workflow: `implement-pass`, `bug-hunt`, `plan-pass`,
`design-bridge`, or `docs-sweep`.
