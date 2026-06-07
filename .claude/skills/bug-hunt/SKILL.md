---
name: bug-hunt
description: Use when EXISTING behavior is broken, wrong, or unexpected — "this isn't working", errors, "why is Y happening". Investigates root cause before fixing. Not for building new behavior.
---

# Bug hunt

Find the root cause before changing anything. Don't patch symptoms. This skill is for **existing
behavior that's broken** — building new behavior is `implement-pass`.

## Steps

1. **Reproduce** — establish the exact steps and the expected vs actual behavior. For UI, reproduce it in a browser and check the console/network.
2. **Locate** — trace to the root cause. Use `git diff` / recent changes and the `explorer` agent for wide searches. Read the relevant code before theorizing.
3. **Propose** — state the root cause and the **smallest safe fix**. If the fix is risky or broad, stop and report before editing.
4. **Fix & verify** — apply the minimal change, then re-run the reproduction and the checks (`npm run lint`, `node --test`; browser for UI).
5. **Record** — if the cause or regression check is worth keeping, add an entry to `docs/BUGS.md`.

## Stop and report if

- You can't reproduce it, the cause is outside scope, or two focused fix attempts fail.

## Report

Reproduction · Root cause · Fix (files changed) · How you verified it.

End with a **Next prompt** block: verify, record the bug, or move to the next item.
