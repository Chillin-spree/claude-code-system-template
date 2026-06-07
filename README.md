# Claude Code System Template

A lean starting point for building **apps of any kind** with Claude Code as the primary
engineering agent — a vanilla web app by default, retargetable to other stacks **and app types**
(CLI, API, library, desktop, mobile, data/ML) via the `stack-setup` skill. It ships an operating
contract (`CLAUDE.md`), auto-triggering workflow skills (`.claude/skills/`), review/research
agents (`.claude/agents/`), format/lint/test hooks plus a pre-commit/push safety gate
(`.claude/settings.json`, `.claude/hooks/`, `.githooks/`), a minimal starter scaffold, and a
small set of repo docs that act as shared memory across sessions. Everything stack-specific
reads from the `CLAUDE.md` project block, so changing stack or app type doesn't touch the rest
of the template.

## Source of truth

| Path                                                                       | What it holds                                                                                                                                                                             |
| -------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `CLAUDE.md`                                                                | Always-read operating contract: read order, project block, communication, guardrails.                                                                                                     |
| `README.md`                                                                | This file — purpose, the doc map, and how to start a project.                                                                                                                             |
| `docs/STATUS.md`                                                           | Current workflow state, active feature, recent activity, and "Later".                                                                                                                     |
| `docs/features/<feature>.md`                                               | Durable per-feature scope, passes, acceptance, and follow-ups.                                                                                                                            |
| `docs/DECISIONS.md`                                                        | Durable product / UX / technical / workflow decisions (stub until first one).                                                                                                             |
| `docs/BUGS.md`                                                             | Meaningful bugs, root causes, and regression checks (stub until first one).                                                                                                               |
| `.claude/skills/`                                                          | Workflows (auto-trigger): kickoff, plan-pass, implement-pass, bug-hunt, design-bridge, docs-sweep, stack-setup. Plus `ship` (manual) and `web-app` (conventions reference that co-loads). |
| `.claude/agents/`                                                          | Subagents: `explorer` (read-only research), `reviewer` (diff vs. plan).                                                                                                                   |
| `.claude/settings.json`                                                    | Format-on-edit, lint/test gate, secret-path guard, and commit/push safety gate; permission rules.                                                                                         |
| `.claude/hooks/`                                                           | Hook scripts: `precommit-safety.sh` (commit/push secret + lint/test gate) plus `guard-secret-paths.py` / `guard-git.py` / `format-on-edit.py`, called by `settings.json`.                 |
| `.githooks/`                                                               | Git hooks that run the same safety gate on terminal commits/pushes (enabled by `npm install`).                                                                                            |
| `.claude/launch.json`                                                      | Serve config used by the Claude Preview / Launch panel (default: `python3 -m http.server 8000`).                                                                                          |
| `package.json`                                                             | Scripts (`lint`, `format`, `test`, `serve`) + dev-only tools (ESLint, Prettier).                                                                                                          |
| `eslint.config.js`, `.prettierrc.json`, `.prettierignore`, `.editorconfig` | Code-quality + formatting rules, consistent across machines.                                                                                                                              |
| `.github/workflows/ci.yml`                                                 | GitHub Actions — re-runs lint + tests on every push and pull request.                                                                                                                     |
| `index.html`, `main.js`, `styles.css`, `example.test.js`                   | Minimal vanilla starter scaffold + a placeholder test (the default; `stack-setup` swaps it for your app type).                                                                            |

## Start a new project

1. Copy this folder. **Declare the stack in the `CLAUDE.md` project block — or run `stack-setup`
   — vanilla is the default.** Then fill in the rest of the **Project** block (name, north star,
   active systems).
2. Run `npm install` — installs the dev tools and turns on the automatic checks and the git
   safety hooks (commit/push secret + lint/test gate).
3. Set the current state in `docs/STATUS.md`.
4. Replace the placeholder scaffold (`index.html` / `main.js` / `styles.css` / `example.test.js`),
   describe the first feature in `docs/features/<feature>.md`, and start working — the skills
   trigger from how you phrase requests ("let's add X", "this is broken", "where were we").

If the secret guard ever flags something harmless, add `allowlist-secret` on that line to skip
it (instead of disabling the gate).

## Extending it

- **Change stack or app type:** run `stack-setup` (or edit the `CLAUDE.md` project block) — it
  retargets the toolchain (manifest, linter, test runner, hooks, CI); everything else is
  stack-agnostic.
- **Add a workflow:** drop a `<name>/SKILL.md` in `.claude/skills/` with a clear `description` —
  it auto-loads when a request matches. Research/review agents live in `.claude/agents/`.
- **Stack-specific facts live only in the `CLAUDE.md` project block** — read from there, never hardcode.

## Repo docs beat memory

Repo docs are authoritative for project state and travel with the code. Claude Code's personal
memory holds collaboration preferences, not project facts. When the two conflict on a project
fact, trust the repo docs.

## License

MIT — see `LICENSE`.
