---
name: docs-sweep
description: Use only for documentation work — aligning docs before review/release/handoff, stale docs, or recording a durable decision or meaningful bug. Makes no code changes.
---

# Docs sweep

Align the repo docs with reality. **Documentation only — this skill makes no code changes.**
Repo docs are the cross-session source of truth, so keep them current and non-duplicative.

## Check each, update only where stale

- **`docs/STATUS.md`** — current workflow state, active feature, next step, recent activity (trim to the latest 5–8).
- **`docs/features/<feature>.md`** — scope, passes, acceptance, follow-ups for the active feature.
- **`docs/DECISIONS.md`** — add an entry only for a _durable_ product/UX/technical/workflow decision.
- **`docs/BUGS.md`** — add an entry only for a _meaningful_ root cause or regression check.
- **`README.md`** / **`CLAUDE.md`** — only if the project map or an operating rule actually changed; keep CLAUDE.md lean.

## Rules

- Don't duplicate feature specs outside their feature file.
- Don't expand DECISIONS/BUGS with routine churn — durable facts only.
- Convert relative dates to absolute.

## Report

Docs updated · Docs intentionally left unchanged · Any source-of-truth conflicts found.
