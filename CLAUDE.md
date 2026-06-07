# Claude Code Operating Manual

Always-read operating contract for Claude Code sessions in this repository.

## Read order

Read these in order at the start of work. Read by path on demand — do not `@import`
(that inlines everything every session and defeats on-demand loading).

1. `CLAUDE.md` (this file).
2. `docs/STATUS.md` — current workflow state.
3. The active feature file, **only if** `docs/STATUS.md` names one (`docs/features/<feature>.md`).

Read `docs/DECISIONS.md` and `docs/BUGS.md` only when the task touches them.

## Project

- **Name**: TBD
- **North star**: TBD — what this product is for and who it serves.
- **Active systems**: TBD
- **Stack**: vanilla HTML/CSS/JS — no framework, no bundler. _(default; swap per project)_
- **Commands**:
  - format — `npx prettier --write .`
  - lint — `npm run lint`
  - test — `node --test`
  - build — (none)
  - serve — `python3 -m http.server 8000`
- **Stack conventions** (default, vanilla): ES modules; no framework or build step — if a task
  seems to need one, **stop and ask**.

> This project block is the single source of truth for stack, commands, and stack conventions.
> Rewrite it when the stack or app type changes — a framework stack states its own
> component/build rules. The `stack-setup` skill does this and re-aligns the toolchain.

## Communication

Assume the reader is comfortable with computers and their operating system but is a **beginner
at software and app development**. Explain in plain language: expand acronyms on first use,
prefer short sentences and concrete analogies, and say what a step does and why before how.
Be precise, not dumbed-down. (Adjust this audience per project.)

## Guardrails

- **Smallest safe change.** Do the least that delivers the outcome.
- **Stay in the active task.** Don't touch unrelated files or do drive-by cleanup.
- **Never, without explicit instruction:** commit or push, delete files, change unrelated
  files, or add dependencies or frameworks.
- **High-risk areas — plan before editing:** auth, secrets, data, CI/CD, deployment, public APIs.
- For destructive or hard-to-reverse actions, confirm first.

## Verification

- Run relevant checks (lint, tests) before claiming done, or say why they were skipped.
- **UI work must be opened in a browser and exercised** before you claim it works.

## Reporting

When there's a genuine next step, end with a **Next prompt** block: one paste-ready prompt,
phrased as the user would send it. Skip it when the work is done or the next move is the
user's to make — don't invent a speculative one. Add a second only on a real fork.

## Source of truth

Repo docs are authoritative for project state and beat memory on conflict — if they disagree,
trust the docs and call out the conflict. The full doc map lives in `README.md`.

Reusable workflows are skills in `.claude/skills/`: kickoff, plan-pass, implement-pass,
bug-hunt, design-bridge, docs-sweep, and stack-setup auto-load when your request matches;
`ship` is manual (`/ship`). `web-app` is a web-conventions reference that co-loads to inform
UI work — not a workflow.
