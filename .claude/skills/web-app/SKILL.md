---
name: web-app
description: "Domain-knowledge reference, NOT a workflow: web UI conventions — semantic HTML, accessibility, performance, SEO, client-side security (universal), plus stack-specific build conventions that follow the project's declared stack. Loads to INFORM how UI is built or edited; never decides the workflow."
---

# Web app — UI conventions reference

**This is a reference, not a workflow.** It co-loads to inform _how_ UI is built or edited inside
`implement-pass`, `bug-hunt`, or `design-bridge`; it never owns the action decision. The
**universal** half always applies; the **stack-specific** half follows the declared stack in the
CLAUDE.md project block.

## Universal (always apply, any stack)

### HTML & semantics

- Semantic elements (`<header>`, `<nav>`, `<main>`, `<button>`, `<label>`) over `<div>` soup.
- One `<h1>` per page; keep heading order sequential.
- Associate every form control with a `<label>`; prefer native validation.

### Accessibility

- Keyboard reachable with visible focus for every interactive element.
- Meaningful `alt` text; ARIA only to fill gaps native HTML can't.
- Color contrast meets WCAG AA.

### CSS

- Drive theming from design tokens / custom properties (`--vars`).
- Mobile-first; relative units (`rem`/`%`/`clamp`) over fixed pixels.
- Respect `prefers-reduced-motion` and `prefers-color-scheme`.

### Performance

- Defer non-critical scripts; lazy-load offscreen images (`loading="lazy"`).
- Minimize layout thrash; keep heavy sync work off the main thread.

### SEO

- `<title>`, meta description, Open Graph tags; one descriptive `<h1>`; meaningful URLs.

### Client-side security

- Never put secrets / API keys in client code.
- Treat all user input as untrusted; escape before inserting into the DOM.
- Avoid `innerHTML` / `eval` / `new Function` with untrusted data; keep markup CSP-friendly.

## Stack-specific (follow the CLAUDE.md project block)

- **Vanilla (default):** ES modules (`<script type="module">`, `import`/`export`);
  `addEventListener` over inline handlers; `textContent` over `innerHTML`; no framework, no
  bundler — if a task seems to need one, stop and ask.
- **Framework stack (React/Vite, Next.js, etc.):** follow that framework's component, state,
  routing, data, and build conventions, and its test toolchain from the project block. Don't
  drop to raw DOM manipulation inside a framework.

## Before claiming done

Open the change in a browser (the project's `serve` command) and exercise it — including
keyboard and a narrow viewport.
