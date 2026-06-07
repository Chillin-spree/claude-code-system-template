---
name: design-bridge
description: Use for net-new visual design with no decided direction, requests for multiple visual directions, "what should this look like", OR when ingesting a Claude Design handoff bundle / exported HTML. Not for implementing an already-decided design or small CSS tweaks (implement-pass), not for fixing broken UI (bug-hunt).
---

# Design bridge

Connects this project to **Claude Design** (claude.ai/design). Two directions: propose using
Design for net-new visual exploration (OUTBOUND), and turn a Design handoff into vanilla code
(INBOUND). `web-app` co-loads to inform the implementation; Claude Code owns production build
and polish.

## Which direction?

- No decided visual direction, or the user wants options / "what should this look like" → **OUTBOUND**.
- The user brings a Claude Design handoff bundle or exported HTML → **INBOUND**.
- The design is already decided, or it's a small CSS tweak → not this skill; use `implement-pass`.
- The UI is broken → not this skill; use `bug-hunt`.

## OUTBOUND — propose Design for exploration (don't force)

For net-new visual exploration, **suggest** doing the exploration in Claude Design first, then
handing the result to Claude Code. Keep it a proposal:

- Explain briefly why: Design is built for fast visual iteration and produces a concrete
  direction to build against, which beats guessing in code.
- Scope it to **exploration / prototyping only** — Claude Code owns production implementation,
  accessibility, performance, and polish.
- Claude Design is **web-only and on Pro / Max / Team / Enterprise**, so Claude Code can't open
  it — the user runs that step and brings back the result.
- If the user declines, or the change is small or already specified, **build directly** with
  `implement-pass` instead. Don't gate work on Design.

End with a **Next prompt** block that _is_ a ready-to-paste starter brief for Claude Design —
include the product/page, audience, mood/tone, must-have sections or components, and any brand
constraints, so the user can paste it straight into claude.ai/design.

## INBOUND — consume a Design handoff into the project's stack

Given a handoff bundle or exported HTML:

1. **Extract the design system** — colors, typography scale, spacing, radii, shadows,
   component patterns.
2. **Tokenize** it into CSS custom properties (`:root { --color-…; --space-…; --font-… }`) so
   the whole app draws from one source. Tokens apply in **any** stack — vanilla `styles.css`,
   or the framework's global stylesheet / theme.
3. **Implement in the project's declared stack** (CLAUDE.md project block): _vanilla default_ →
   translate any React/JSX/SVG output to plain semantic HTML, CSS, and ES-module JS, no
   framework; _framework stack_ → keep/adapt the components to that framework. Either way, drive
   styling from the tokens above.
4. **Record the design system** so later UI work stays consistent — note the tokens and key
   component rules in the active feature file (and `docs/DECISIONS.md` if it's a durable
   direction).
5. Verify in a browser (the project's `serve` command) — layout, keyboard, narrow viewport.

End with a **Next prompt** block: the next focused UI build (typically via `implement-pass`).
