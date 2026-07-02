# PhlexKit — component inventory & porting status

Target: parity with the full [ruby_ui](https://ruby-ui.com) catalog (53 components),
every one ported to Phlex + co-located vanilla CSS + `--pk-*` tokens.

**Status: 53 / 53 ported — full ruby_ui parity, all render-tested (102 tests, 722 assertions green).**
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
- Not ported (unfinished upstream): combobox's input/badge trigger variants — their
  controller actions don't exist in ruby_ui's own combobox controller.

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
| Stars | — | — | rating display (PhlexKit extra, not in ruby_ui) |
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
