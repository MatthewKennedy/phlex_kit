# PhlexKit — component inventory & porting status

Target: parity with the full [ruby_ui](https://ruby-ui.com) catalog (53 components),
every one ported to Phlex + co-located vanilla CSS + `--pk-*` tokens.

**Status: full ruby_ui parity (53/53) PLUS the shadcn/ui-only components — 70 component
folders, all render-tested (123 tests, 1206 assertions green). Published to
rubygems.org (v0.2.0).** Default theme mirrors ui.shadcn.com's live token system
verbatim (neutral palette, accent/input/ring tokens, derived radii, --pk-chart-1..5)
with control geometry verified numerically against the live site. shadcn additions
beyond ruby_ui: spinner, kbd, label, button_group, item, input_group, radio_group,
scroll_area, slider, input_otp, drawer (on the sheet machinery), menubar,
navigation_menu (shared controller), resizable, attachment, avatar_group.

## Next

- **Sidebar collapsible/offcanvas mode** — ours is the static rail only; upstream's
  cookie-persisted collapse + mobile sheet behaviour was deliberately deferred.
- **Checkbox group** — ruby_ui's cross-checkbox "at least one required" controller,
  noted as skipped in checkbox.rb.
- **Menubar/NavigationMenu keyboard nav** — arrow-key movement between triggers and
  items (we have click/hover/escape).
- **Dogfood in revue** — swap revue's hand-rolled UI::* for the published gem; the
  first real production host for the engine wiring and the UI alias path.
- Wave 1 (pure style): skeleton, shortcut_key, switch, radio_button, breadcrumb, empty, bubble, message.
- Wave 2 (Stimulus, self-contained): accordion, collapsible, tabs, toggle, toggle_group.
- Wave 3 (overlays): dialog, sheet, popover, hover_card, context_menu.
- Wave 4 (remaining tractable): clipboard, theme_toggle, pagination, message_scroller, masked_input, codeblock.
- Wave 5 (the heavy tier): toast, carousel, combobox, command, calendar, date_picker,
  data_table, chart, plus the `form` upgrade (Form shell + FormField live validation,
  with input/textarea/checkbox/radio_button/native_select/select wired as targets).
- 33 Stimulus controllers total; every external JS dependency ruby_ui pulls in is
  replaced: `motion` → native Web Animations API; `@floating-ui/dom` → CSS positioning
  (popover/hover_card/context_menu/clipboard/combobox); `maska` → vanilla mask;
  `rouge` → plain codeblock; `embla-carousel` → translate-based carousel engine;
  `fuse.js` → substring filter (command); `mustache` → tiny {{key}} interpolator
  (calendar); `chart.js` → not bundled (thin wrapper: uses `window.Chart` if the host
  ships it, else dispatches `phlex-kit--chart:connect` with `{ canvas, options }`).
- Combobox's input/badge trigger variants shipped unfinished upstream (no controller
  support in ruby_ui itself); PhlexKit completes them — open-on-focus filtering,
  removable selection chips, backspace removal, clear-all, field-level keyboard nav.

See `docs/` for the feasibility report, PRD, and spec.

## Shipped (22, from revue)

Adapted from revue's production-proven vanilla-CSS kit. All render-tested.

| Component | Parts | Stimulus | Notes |
|---|---|---|---|
| Alert | alert, title, description | — | variant-driven |
| AlertDialog | 8 parts | `phlex-kit--alert-dialog` | |
| AspectRatio | — | — | |
| Avatar | image, fallback | `phlex-kit--avatar` | |
| Badge | — | — | variant/size |
| Button | — | — | variant/size, reactive-ready via `mix` |
| Card | header/title/description/content/footer | — | multi-part compose |
| Checkbox | — | — | |
| DropdownMenu | trigger/content/item/label/separator | `phlex-kit--dropdown-menu` | CSS-positioned (no floating-ui) |
| FormField | label/hint/error | `phlex-kit--form-field` | live validation; Form shell in `form/` |
| Input | — | — | |
| Link | — | — | |
| NativeSelect | group/option/icon | — | |
| Progress | — | — | |
| Select | 8 parts | `phlex-kit--select` + `--select-item` | custom, CSS-positioned |
| Separator | — | — | |
| Sidebar | 10 parts | — | |
| ~~Stars~~ | — | — | dropped post-v0.2.1 (not in ruby_ui or shadcn) |
| Table | header/body/row/cell/head/footer/caption | — | |
| Textarea | — | — | |
| Tooltip | trigger/content | — | |
| Typography | heading/text/blockquote/inline_code/inline_link | — | |

## Porting checklist (per component — kept for future additions)

1. `mcp__ruby-ui__view_items_in_registries` → source + component deps (port leaf deps first).
2. Create `app/components/phlex_kit/<name>/<name>.rb` (+ parts), `module PhlexKit`,
   `< BaseComponent`, `VARIANTS`/`SIZES` constants, `mix`-passthrough, `.fetch` fail-loud.
3. Co-locate `<name>.css` — `.pk-<name>` classes, `var(--pk-*)` tokens, no hardcoded colours.
4. Rename any Stimulus identifiers to `phlex-kit--<name>`; ship the controller under
   `app/javascript/phlex_kit/controllers/` and register it in `controllers/index.js`.
5. Regenerate the manifest (add the `@import url(...)` line).
6. Add `test/components/<name>_test.rb` (class list, fail-loud, attrs pass-through).
