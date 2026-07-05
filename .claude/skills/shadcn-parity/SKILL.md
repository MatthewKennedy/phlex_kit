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

## 1. Audit from the LOCAL shadcn checkout (primary since 2026-07-05)

The shadcn/ui monorepo lives at `~/Developer/ui`. It is the primary audit
source — faster and more exact than the live page:

- **Markup + parts API**: `~/Developer/ui/apps/v4/registry/bases/radix/ui/<slug>.tsx`
  (component functions, data-slots, props, asChild spots).
- **Metrics**: `~/Developer/ui/apps/v4/registry/styles/style-nova.css` — the
  docs-default "nova" style's semantic `.cn-<slug>*` classes. Extract with
  `awk '/\.cn-<slug>/,/^  }$/' style-nova.css`. Tailwind classes decode
  deterministically (h-8 = 2rem, px-2.5 = .625rem, rounded-lg = var(--pk-radius),
  rounded-md = calc(r-2px), rounded-sm = calc(r-4px), ring-3 = the kit focus
  box-shadow recipe). IMPORTANT: nova classes COMPOSE with the base classes in
  the .tsx — read both (e.g. toggle's hover:bg-muted lives in the base cls).
- **Their demo content (copy verbatim)**: `~/Developer/ui/apps/v4/examples/radix/<slug>-*.tsx`.
- **Example section order/titles**: `grep '^### ' ~/Developer/ui/apps/v4/content/docs/components/radix/<slug>.mdx`.
- The live page (`ui.shadcn.com/docs/components/radix/<slug>`) is now only for
  visual spot-checks and user side-by-side screenshots.
- Tokens were lifted verbatim from their `:root`/`.dark` on 2026-07-03 into
  `_tokens.css`. If colors look off, re-extract and diff before touching
  component CSS.

## 1b. Established kit conventions (use these, don't invent new ones)

- Their `asChild` → an `href:` param (renders `<a>`) and/or `as: :button`.
  Precedent: Button, Badge, Item, Marker, Bubble.
- Their `data-icon="inline-start"/"inline-end"` attribute is adopted VERBATIM
  (`data: { icon: "inline-start" }`) — CSS `:has(> [data-icon=…])` tightens
  the near-side padding. Precedent: Button, Badge, Toggle, InputGroup, Kbd.
- Theme-forked values (their `dark:` variants) are written DARK-FIRST, with
  light overrides in BOTH blocks:
  `:root[data-theme="light"] …` AND
  `@media (prefers-color-scheme: light) { :root[data-theme="system"] … }`.
  Precedent: avatar (first), button, checkbox, input, bubble.
- One-off example colors use `light-dark(…)` inline styles — works because
  `_tokens.css` sets `color-scheme` per theme. Precedent: alert/badge Custom
  Colors.
- Form-control grammar (input/textarea/select/native-select/otp/input-group):
  translucent `--pk-input` 30% fill in dark / transparent in light, hover
  step to 50% where theirs has one, focus ring on `--pk-ring` (NEVER brand),
  `aria-invalid` ring at red 40% dark / 20% light, disabled fill 80%/50%.
- Overlays are kit-unified at nova's `rgb(0 0 0/.1)` + `blur(4px)`, with an
  `@supports not (backdrop-filter: …)` fallback darkening to `/50` — always
  change all five (dialog/alert-dialog/sheet/drawer/command) together.
- If a page is too big for the current session (controller build, tutorial
  port), DON'T half-do it: leave it `[ ]` in PARITY.md with a dated
  audit-scope note and move on. Precedent: calendar, chart, combobox, field.

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
- Overlays are unified: `rgb(0 0 0 / .1)` + `backdrop-filter: blur(4px)`
  (fallback `/50` without backdrop-filter support).
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

Check the page off in PARITY.md (repo root) with a one-line note of what
the audit found — that file is the sweep's source of truth across sessions.

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
