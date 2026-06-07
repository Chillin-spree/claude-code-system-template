---
name: stack-setup
description: Use when starting a project from this template, or declaring/switching the stack or app type (web, CLI, API, library, desktop, mobile, data/ML), or wiring the toolchain — "set this up as a Next.js app", "make this a Python CLI", "turn this into a library". Writes the CLAUDE.md project block and re-aligns the toolchain (manifest, linter, test runner, hooks, CI) to it. Defaults to vanilla web if none is given. Not for orienting in an already-configured project (kickoff).
---

# Stack setup

Declare or switch the project's **stack and app type**, and wire the toolchain to match. The
**CLAUDE.md project block is the single source of truth** for stack, commands, and conventions;
this skill writes it and re-aligns everything else, so nothing else hardcodes a stack. The
template ships a lean vanilla web default — this is how it transforms into any other app.

This skill **configures / changes the stack + toolchain**; `kickoff` only orients in an
already-configured project.

## Steps

1. **Confirm the stack and app type.** Name the language/framework and the archetype (web, CLI,
   HTTP API/server, library/package, desktop, mobile, data/ML). If none is given, **default to
   vanilla web** and say so.

2. **Write/replace the CLAUDE.md project block** — Stack, the five Commands (format / lint /
   test / build / serve), and Stack-conventions. Map the commands to the archetype; read `serve`
   as "run/serve", and use `(none)` where a command doesn't apply:
   - **Web** (default vanilla): format `npx prettier --write .` · lint `npm run lint` · test
     `node --test` · build `(none)` · serve `python3 -m http.server 8000`. Frameworks
     (React+Vite / Next): test `vitest run`, build `vite build` / `next build`, serve `npm run dev`.
   - **CLI tool:** build only if compiled; serve → the run command (e.g. `node bin/cli.js`, `python -m app`).
   - **HTTP API / server:** serve → start the server (e.g. `npm start`, `uvicorn app:app --reload`).
   - **Library / package:** build → the bundler/compiler; serve `(none)`.
   - **Desktop / mobile** (Electron/Tauri, Expo/RN): build → package; serve → the dev runner.
   - **Data / ML** (Python): format `ruff format` · lint `ruff check` · test `pytest` · build
     `(none)` · serve → `python main.py` or the notebook.

   For non-JS stacks, use that language's formatter / linter / test runner in place of
   Prettier / ESLint / `node --test`.

3. **Re-align the whole toolchain to the declared stack** — it all ships JS/web-tuned, so retarget each:
   - **Language manifest** — `package.json` for JS; otherwise its equivalent (`pyproject.toml`,
     `Cargo.toml`, `go.mod`, …) with the matching scripts/targets and dependencies.
   - **`package.json` scripts** (JS) — `lint` / `test` / `build` / `serve` to match the block.
   - **`eslint.config.js`** — parser, plugins, globals for the stack (JS); for other languages,
     use that linter's own config file instead.
   - **`.claude/hooks/precommit-safety.sh`** — the project-checks step reads lint/test from the
     block, but its "deps installed" guard is JS-specific (`package.json` + `node_modules`).
     Repoint it to the new stack's manifest + install marker (e.g. `pyproject.toml` + `.venv`) so
     checks run for the right language and still no-op cleanly before install.
   - **`.claude/hooks/format-on-edit.py`** — widen the Prettier extension list to the stack's
     source types (e.g. add `.jsx` / `.ts` / `.tsx` / `.vue` / `.svelte`).
   - **`.claude/settings.json`** — the Stop hook's lint+test command; **leave the permission rules
     and the `guard-secret-paths.py` / `guard-git.py` hooks untouched**.
   - **`.claude/launch.json`** — the Claude Preview serve config. Repoint
     `runtimeExecutable` / `runtimeArgs` / `port` to the project block's `serve` command (same
     source of truth — e.g. `npm run dev`); for archetypes with no serve (CLI, library), remove
     the configuration entry.
   - **`.github/workflows/ci.yml`** — runtime (Node/Python/…), the install step, and the run steps.
   - **`.githooks/*`** — no change; they call the shared scan, which reads commands from the block.

4. **Don't over-reach** — add only what the declared stack needs, and **confirm before
   scaffolding** entry-point files or installing anything.

## Report

Stack + app type declared · CLAUDE.md project block updated · toolchain re-aligned (list files) ·
anything still needing the user (install, scaffold).

End with a **Next prompt** block: the likely next step — scaffold the entry point, or
`implement-pass` the first feature on the new stack.
