---
name: shadcn-parity
description: Bring one PhlexKit component to exact parity with its live shadcn/ui docs page — audit the page, upgrade the kit where shadcn moved past ruby_ui, and recreate every example in the test/dummy docs site. Use when the user names a ui.shadcn.com component page, asks to "match/replicate/compare" a component against shadcn, or says a component looks out of date.
---

# shadcn-parity: match a component to its live shadcn/ui page

The kit descends from ruby_ui, which was built on an OLDER shadcn. When a
page is audited, expect THREE kinds of drift, in this order of importance:

1. **Missing kit API** — new parts (CardAction, AlertDialogMedia,
   AttachmentTrigger…), new props (`state:`, `size:`, `orientation:`,
   `variant:` on actions), new CSS systems (`--card-spacing`-style variables,
   footer bands, centered media stacks).
2. **Metric drift** — weights, tracking, insets, radii, blur strength.
   Measure, don't eyeball.
3. **Missing docs examples** — every use case on their page must exist as a
   demo on ours.

Never stop at #3. The docs comparison is the *detector*; the kit upgrade is
the deliverable. (Typography found heading sizes that never applied; card
found five missing features. Assume the page will find something.)

## 1. Read the live page

URL shape: `https://ui.shadcn.com/docs/components/radix/<slug>` (components)
or `/docs/utils/<slug>` (utilities). The non-`/radix/` URL redirects.

- `get_page_text` gives the prose: the **Examples** headings, the
  **Composition** tree, the **API Reference** tables (props/types/defaults),
  and Accessibility notes. This is the primary source — read all of it.
- For pixel parity, measure computed styles in the page with
  `javascript_tool`: their parts carry `data-slot="<part>"` attributes —
  `getComputedStyle(document.querySelector('[data-slot="card-header"]'))`.
  Keep JS results SMALL and never dump `className` strings (the extension
  blocks responses that look like data exfiltration — split into several
  narrow queries instead).
- Tokens were lifted verbatim from their `:root`/`.dark` on 2026-07-03 into
  `_tokens.css`. If colors look off, re-extract and diff before touching
  component CSS.

## 2. Upgrade the kit (if drift found)

Follow CLAUDE.md conventions strictly. Specifics that recur in parity work:

- New variants/props: fail-loud `FETCH` maps; `data-state`/modifier classes.
- Spacing systems: one `--pk-<component>-spacing` variable driving every gap
  and inset (see card.css, alert_dialog.css) — negative margins let footers
  and edge-to-edge content escape the padding.
- Their footer treatment (card, dialogs): full-bleed band — `border-top`,
  `color-mix(in oklab, var(--pk-surface-2) 50%, transparent)` fill.
- Shimmering titles reuse the `.pk-shimmer` recipe scoped to
  `[data-state="…"]` selectors; the `pk-shimmer` keyframes are global.
- Overlays are unified: `rgb(0 0 0 / .5)` + `backdrop-filter: blur(8px)`.
- Full-card triggers sit at `z-index: 1` with actions at `z-index: 2`, hover
  tint + focus ring on the card via `:has()`.
- Icons: the kit bundles no icon set. Use emoji/glyph stand-ins in demos and
  accept SVGs from callers.
- RTL sections on their pages are documentation here (README "RTL"), never a
  component. Skip their RTL demos.
- New CSS file → regenerate the manifest (CLAUDE.md snippet). New controller
  → register in `controllers/index.js` (both lists, sorted) + `node --check`.
- Add/extend tests in `test/components/` for every new prop/part (fail-loud
  assertions included).

## 3. Recreate the examples in the docs site

One page class + one example class per use case:

- `test/dummy/app/components/docs/pages/<slug>.rb` — `Docs::Pages::<Camel>`,
  `self.description = "<their page description>"`, one `demo` line per
  example titled like theirs ("Basic", "Sizes", "With icon"…).
- `test/dummy/app/components/docs/examples/<slug>/<example>.rb` — module path
  MUST match the directory (`Docs::Examples::<Camel>::<Example>`, no suffix
  renames — Zeitwerk). Plain `Phlex::HTML`, all renders fully qualified
  (`PhlexKit::X`).
- The Code tab extracts the `view_template` body from the file by
  indentation — keep files machine-formatted, comments inside view_template
  are shown to readers (write them as user-facing).
- Reuse their demo CONTENT (file names, copy, numbers) so side-by-side
  comparison is direct.
- Layout helpers available in examples: `.stack`, `.row`, `.w-sm/.w-md/.w-lg`,
  `.docs-slide`, `.docs-panel`. Inline `style:` is fine for one-offs.
- Unit tests cannot nest `render` (RenderHelper returns strings) — test parts
  standalone; compose only in examples.

## 4. Verify, then commit

```bash
bundle exec rake test                      # must stay green
curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:3999/docs/<slug>
curl -s http://127.0.0.1:3999/docs/<slug>  # grep for the new classes/states
```

Dev server reloads Ruby/CSS automatically; restart puma only after config or
asset-path changes (`pkill -f "puma.*3999"` then
`bundle exec puma -p 3999 test/dummy/config.ru`). JS errors surface in the
site's red on-page banner — screenshot-visible.

Ask the user to reload and compare, or screenshot the tab yourself if the
browser tools are connected. When they send side-by-side screenshots, treat
every visible difference as a bug until explained (media tile shape, button
widths, blur strength — all were real).

Commit per page, message shaped like:

    <Component> to shadcn's current spec; docs page with their examples

    <kit changes, why ruby_ui lacked them>
    <docs examples added>

## Recurring traps

- `get_page_text` may return only the sidebar nav on JS-heavy pages — wait
  2s after navigate; if it persists, pull `main` via `javascript_tool`.
- Phlex escapes text in `style {}`/`script {}` — wrap trusted CSS/JS in
  `safe(...)` or quoted strings silently break.
- Renaming sweeps miss interpolated strings (`"ui-heading-#{n}"`) — grep for
  `ui-` when a style mysteriously doesn't apply.
- Their "size" props usually change a spacing VARIABLE, not per-rule sizes.
- After changing shared CSS (tokens, box-sizing, radii), spot-check 2–3
  other docs pages — shared-token changes travel.
