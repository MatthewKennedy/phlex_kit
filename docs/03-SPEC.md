# PhlexKit — Technical Specification

**Companion to:** [PRD](02-PRD.md) · **Reference implementation:** `~/Developer/phlex_kit` (53/53 built)

This spec describes the architecture and conventions so the remaining components can
be built consistently, and the whole reviewed. It is grounded in the working prototype
— read the prototype alongside this doc; the shipped components are the canonical
examples of every pattern below.

## 1. Stack & dependencies

- **Ruby** ≥ 3.2, **Rails** 7.1–8.x, **Propshaft** (asset pipeline).
- Runtime gem deps: `phlex-rails` (>= 2.0, < 3), `railties` (>= 7.1, < 9). **Nothing else** —
  no `tailwind_merge`, no `rouge`, no charting gem.
- JS: `@hotwired/stimulus` only. Controllers must not import other npm packages
  (ruby_ui's `motion`, `@floating-ui/dom`, `maska` are deliberately replaced — see §7).
- **License:** MIT. Ported components keep an attribution comment
  (`# … ported from ruby_ui's RubyUI::X`). ruby_ui is MIT; this is a derivative work.

## 2. Repository layout

```
lib/phlex_kit.rb                     # requires; loads engine under Rails
lib/phlex_kit/{version,configuration,base_component,engine,propshaft_skip_source}.rb
lib/generators/phlex_kit/{install,component}/…
app/components/phlex_kit/<name>/<name>.rb (+ parts) + <name>.css + <name>_controller.js  # one folder per component
app/assets/stylesheets/phlex_kit/_tokens.css                      # default --pk-* theme + utilities
app/assets/stylesheets/phlex_kit/phlex_kit.css                    # manifest (@import url(...) each css)
app/javascript/phlex_kit/controllers/index.js                    # central registry, phlex-kit--* identifiers
config/importmap.rb                                              # globs component folders, re-pins each _controller.js
test/…                                                           # render + wiring + asset-guard tests
```

## 3. The engine — four wiring pieces (all implemented, `lib/phlex_kit/engine.rb`)

1. **Asset path:** append `app/components` and `app/assets/stylesheets` to
   `config.assets.paths` so CSS resolves co-located with each `.rb`.
2. **Zeitwerk collapse:** `Rails.autoloaders.main.collapse("app/components/phlex_kit/*")`
   so `button/button.rb` → `PhlexKit::Button` and `card/card_header.rb` →
   `PhlexKit::CardHeader` (flat constants, no folder segment).
3. **Propshaft source-skip:** prepend a module overriding the private
   `Propshaft::LoadPath#without_dotfiles` to reject `.rb/.erb/.haml/.slim/.rbi`, so
   Ruby source is never served from `public/assets/`. Guarded by
   `test/assets/asset_load_path_test.rb` (fails loudly if Propshaft changes).
4. **JS registration:** append `config/importmap.rb` to the host importmap; it
   `pin_all_from`s the controllers dir. Host calls `registerPhlexKitControllers(app)`.

Plus: `config.after_initialize` optionally aliases `UI = PhlexKit` when
`config.define_ui_alias` is true.

## 4. Naming conventions

| Thing | Convention | Example |
|---|---|---|
| Module / class | `PhlexKit::<Name>` (flat) | `PhlexKit::DropdownMenuItem` |
| Base class | `PhlexKit::BaseComponent` (< `Phlex::HTML`) | |
| CSS class | `.pk-<component>[-<part>]` + bare-word modifiers | `.pk-button.primary.sm` |
| Token | `--pk-<name>` with literal fallback | `var(--pk-brand, #6c8cff)` |
| Stimulus identifier | `phlex-kit--<component>` | `phlex-kit--dropdown-menu` |
| Stimulus data (Ruby) | symbol keys, `_`→`-` by Phlex | `data: { phlex_kit__tabs_target: "content" }` |

## 5. Component authoring conventions

Every component is a `PhlexKit::<Name> < BaseComponent`. The canonical shape (see
`button/button.rb`, `badge/badge.rb`):

```ruby
module PhlexKit
  class Badge < BaseComponent
    VARIANTS = { primary: "primary", secondary: "secondary", … }.freeze   # value => CSS modifier (nil = bare)
    SIZES    = { sm: "sm", md: nil, lg: "lg" }.freeze
    def initialize(variant: :primary, size: :md, **attrs)
      @variant = variant.to_sym; @size = size.to_sym; @attrs = attrs
    end
    def view_template(&) = span(**mix({ class: classes }, @attrs), &)
    private
    def classes = ["pk-badge", VARIANTS.fetch(@variant), SIZES.fetch(@size)].compact.join(" ")
  end
end
```

Invariants (keep all):
- **`**@attrs` passes straight through `mix`** onto the root element — so a caller's
  `class:` augments (not clobbers) ours, and a phlex-reactive `**on(:event)` bundle
  flows on with zero special-casing.
- **`VARIANTS.fetch(...)` fails loud** (KeyError) on an unknown variant — never `[]`.
- **Multi-part components:** one file per constant inside the folder
  (`card/card_header.rb` → `PhlexKit::CardHeader`), sharing one `.css` + one manifest
  entry. Preserve ruby_ui's DOM structure, ARIA roles, `data-slot`s, and SVG icons.
- Keep the attribution comment on the lead class.

## 6. CSS & theming

- Co-located `.css`, plain CSS only, **no Tailwind, no hardcoded colours**. Derive
  geometry from ruby_ui's Tailwind (`h-9`→`2.25rem`, `rounded-md`→`.375rem`, `px-3`→
  `.75rem`, focus ring, …); map semantic colours onto `--pk-*` tokens.
- **Tailwind → token map** (the translation table used throughout):

  | Tailwind | PhlexKit |
  |---|---|
  | `bg-background` | `var(--pk-bg)` (panels use `--pk-surface`) |
  | `bg-card` / `bg-popover` | `var(--pk-surface)` |
  | `bg-muted` / `bg-accent` | `var(--pk-surface-2)` |
  | `text-foreground` | `var(--pk-text)` |
  | `text-muted-foreground` | `var(--pk-muted)` |
  | `bg-primary` / `text-primary` | `var(--pk-brand)` |
  | `text-primary-foreground` | `var(--pk-brand-ink)` |
  | `border` / `border-border` | `var(--pk-border)` |
  | `bg-destructive` / `text-destructive` | `var(--pk-red)` |
  | `bg-primary/10` etc. | `color-mix(in oklab, var(--pk-brand) 10%, transparent)` |

- **Icons**: components never inline glyph SVGs — they render `PhlexKit::Icon`
  with a canonical semantic name (`:chevron_down`, `:x`, …). The glyph data is
  vendored per library under `lib/phlex_kit/icons/` (generated by
  `scripts/generate_icons.rb`; Lucide default, Tabler/Phosphor/Remix opt-in via
  `PhlexKit.config.icon_library`). Exception: purely geometric indicators (the
  dropdown radio dot) stay inline. HugeIcons is excluded for licensing.
- **Optional component-scoped parity slots** use a token→token fallback —
  `var(--pk-sidebar-primary, var(--pk-brand))` — for shadcn tokens the kit collapses
  onto shared tokens (currently only the sidebar's `--pk-sidebar[-text|-accent|-border|-primary|-primary-ink]`).
  They are defined nowhere by default; themes set one only when its value differs
  from the shared token.

- **Tokens** live in `_tokens.css`: `:root` (dark default), `:root[data-theme="light"]`,
  and `@media (prefers-color-scheme: light) :root[data-theme="system"]`. Plus utilities
  `.pk-hidden` and `.pk-contents`. Hosts override by redefining `:root` after the import
  (app assets sort ahead of gem assets), or drop the `_tokens` import and supply their own.
- **Manifest** (`phlex_kit.css`) imports `_tokens.css` then every component CSS —
  **`@import url("…")` form only** (Propshaft fingerprints `url()`; a bare `@import`
  ships un-digested and 404s), and **paths relative to the manifest's own
  `phlex_kit/` directory** (`_tokens.css`, `button/button.css`) — Propshaft resolves
  bare `url()` paths against the referencing file's dir, so a `phlex_kit/…` prefix
  doubles up and 404s. Regenerate whenever a component is added:
  ```ruby
  header = File.read(m)[/\A.*?\n(?=@import)/m]
  lines  = Dir.glob("app/components/phlex_kit/*/*.css").sort.map { |c| %(@import url("#{c.sub("app/components/phlex_kit/","")}");) }
  File.write(m, header + %(@import url("_tokens.css");\n) + lines.join("\n") + "\n")
  ```

## 7. JavaScript / Stimulus

- Interactive components ship a Stimulus controller co-located in the component
  folder at `app/components/phlex_kit/<name>/<name>_controller.js`, connected via
  `phlex-kit--<name>`, and registered in the central
  `app/javascript/phlex_kit/controllers/index.js` (`registerPhlexKitControllers`).
  The module id stays flat (`phlex_kit/controllers/<name>_controller`):
  `config/importmap.rb` globs the component folders and re-pins each file under
  that stable namespace, so hosts and `index.js` never change.
- **No non-Stimulus npm imports.** ruby_ui's external deps are replaced:
  - `motion` (accordion animation) → native **Web Animations API** (`element.animate`).
  - `@floating-ui/dom` (popover/hover_card/context_menu/clipboard/combobox placement) →
    **native `[popover]` + CSS anchor positioning** (Baseline 2026): panels are
    `popover="auto"|"manual"` elements in the top layer, `anchor-name`/`position-anchor`ed
    to their trigger with `position-try-fallbacks` flipping them at viewport edges;
    `anchor-size()` replaces JS width-matching. Context menu is positioned at the cursor
    via the controller (clamped to the viewport); tooltip keeps its CSS-only reveal and
    uses anchor positioning without the popover attribute. Gotchas: gate `display` on
    `:popover-open` (author display beats the UA's `[popover]{display:none}`), and the
    `[popover]` UA `overflow:auto` clips out-of-box hover-bridge pseudos — restate
    `overflow:visible` where bridges exist.
  - `maska` (masked_input) → a small dependency-free mask controller (`#`/`A`/`*`).
  - `rouge` (codeblock highlight) → omitted; plain `<pre><code>`.
- Show/hide: floating panels are native popovers (`showPopover()`/`hidePopover()`,
  state via `:popover-open`); non-floating show/hide uses the `.pk-hidden` utility,
  toggled by controllers.

## 8. Distribution, config, testing

- **Config** (`PhlexKit.configure`): `reactive` (`:auto`/true/false — `reactive?`
  auto-detects phlex-reactive), `define_ui_alias` (expose `UI = PhlexKit`).
- **Reactivity:** `BaseComponent#on` is a no-op returning `{}`; a reactive component
  `include Phlex::Reactive::Component` (only meaningful when the host adds the gem),
  whose real `on` shadows the fallback. Never add phlex-reactive to the gemspec.
- **Generators:** `phlex_kit:install` (prepend manifest `@import`, drop initializer,
  print Stimulus snippet); `phlex_kit:component <name>` (eject folder into host +
  append its `@import`).
- **Tests:** one render test per component (class list, fail-loud, attrs pass-through);
  `manifest_test` (every css imported, all `url()` form); `asset_load_path_test`
  (Propshaft guard). Run standalone (no full Rails app): `test_helper` requires
  `active_support`, `date`, `phlex`, `phlex-rails`, then all component files, and renders
  via `component.call`.

## 9. Remaining components to build (8) — per-component guidance

Read each ruby_ui source under `gem/lib/ruby_ui/<name>/` (clone
`github.com/ruby-ui/ruby_ui`, MIT). Apply §5–§7. For each: author the `.rb` part(s) +
co-located `.css`, port/adapt the controller (rename `ruby-ui--`→`phlex-kit--`,
`ruby_ui__`→`phlex_kit__`; strip non-Stimulus imports per §7), register the controller,
regenerate the manifest, add a render test.

- **toast** — largest. Parts: `toast_region` (the `<ol>` toaster with position/expand/
  max/duration/hotkey values + skeleton `<template>`s per variant + slot templates),
  `toast_item` (swipe/timer), `toast_icon` (variant SVGs), `toast_title`,
  `toast_description`, `toast_action`, `toast_cancel`, `toast_close`, plus the `Toast`
  flash-variant module. Controllers: `toaster_controller.js` (~11KB) + `toast_controller.js`
  (~5.5KB) are **Stimulus-only** → copy + rename verbatim. Author the Ruby faithfully;
  map `bg-popover`→`--pk-surface`, positions via `data-[position=…]` CSS.
- **combobox** — searchable select. Trigger + popover list + search input + options.
  ruby_ui uses `@floating-ui` → anchor-position the panel like the shipped `select`. Reuse
  `select`/`dropdown_menu` patterns.
- **command** — command palette (often in a dialog). Search + grouped items + keyboard
  nav. Compose with the shipped `dialog`. Controller Stimulus-only after positioning swap.
- **carousel** — slides + prev/next + indicators. `carousel_controller.js` is
  Stimulus-only → copy + rename. Author track/slide CSS (scroll-snap or transform).
- **calendar** — month grid, day selection, keyboard nav. `calendar_controller.js` +
  `calendar_input_controller.js` (Stimulus-only). Table/grid CSS.
- **date_picker** — `calendar` inside a `popover` bound to an input. Depends on calendar;
  build calendar first.
- **data_table** — sortable/filterable table with column-visibility + search. Controllers:
  `data_table_controller.js`, `data_table_search_controller.js`,
  `data_table_column_visibility_controller.js` (Stimulus-only). Build on the shipped
  `table` + `dropdown_menu` + `input`.
- **chart** — ruby_ui wraps a JS charting lib. **Decision: no bundled lib.** Ship a thin
  wrapper: a container `<div>`/`<canvas>` + a Stimulus hook reading `data-*`, documented
  as host-supplies-the-lib. (Or skip for v1 — confirm.)

Also: **`form`** — upgrade the shipped `form_field` to ruby_ui's fuller form builder
(`form_field_controller.js` for live validation is Stimulus-only).

## 10. Definition of done (per component)
`.rb` + `.css` created · controller ported & registered (if any) · manifest regenerated
· render test added · `bundle exec rake test` green · attribution comment present.
