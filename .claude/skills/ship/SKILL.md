---
name: ship
description: Commit and push approved work. Manual only — invoke explicitly with /ship; never triggered automatically.
disable-model-invocation: true
---

# Ship

Publish approved work. Only run this when the user explicitly asks to commit or push. Commit and
push are gated by the safety + security scan in `.claude/hooks/precommit-safety.sh` — nothing
ships until it passes and the user approves.

## Steps

1. **Review the tree** — `git status` and `git diff` to see exactly what would be included. If unrelated changes are present, stop and report.
2. **Stage by name** — `git add <path> <path>` for the intended files only. **Never `git add .` or `git add -A`.**
3. **Run the safety + security gate** — `sh .claude/hooks/precommit-safety.sh` against the staged set, then present a human-readable **PASS / FAIL** report:
   - **Secret scan** — PASS, or FAIL with the offending `file:line`.
   - **Staged files** — listed **by name** (confirm scope).
   - **Lint / test** — PASS / FAIL (the project's commands from the CLAUDE.md project block).
   - **On push** — target **branch + remote**, and confirmation it is **not** a force-push.
4. **Commit** — only if the report is **PASS and the user explicitly approves**. Conventional message (`feat:`, `fix:`, `docs:`, `chore:`, `refactor:` …), subject in the imperative, scoped to this change.
5. **Push** — only if the user explicitly asked. Re-confirm branch + remote first; otherwise stop after committing and say so.

On **FAIL**: stop and report exactly what is unsafe — do **not** attempt to commit or push.

> The PreToolUse hook on `git commit` / `git push` runs the same script and hard-blocks the
> operation on failure, so this gate holds even if a step here is skipped.

## Never

- `--no-verify` (skip hooks) or force-push.
- Amend or rewrite published commits.
- Commit unrelated changes or secrets/`.env` files.
- Push when the safety gate failed without reporting first.

## Report

Safety report (PASS/FAIL) · Commit created (hash + subject) · Files included · Checks run · Push completed or intentionally skipped.
