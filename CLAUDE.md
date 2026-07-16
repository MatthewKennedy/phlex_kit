# CLAUDE.md — phlex_kit

Phlex + Rails component kit: the full ruby_ui catalog + shadcn/ui's additions
(70 component families), vanilla CSS on `--pk-*` tokens, `@hotwired/stimulus`
only. Published to rubygems.org as `phlex_kit`. Read `docs/03-SPEC.md` for the
architecture; `docs/07-TOKENS.md` for the full `--pk-*` token reference;
`ROADMAP.md` for the inventory; this file for how to work here.

## Commands

```bash
bundle exec rake test                 # unit suite (fast, no Rails boot; excludes test/system)
bundle exec rake test:system          # browser suite — Capybara + Cuprite (headless Chrome)
                                      # drives /gallery + /docs/<slug>; HEADLESS=0 to watch
node --check app/components/phlex_kit/<name>/<name>_controller.js
bundle exec puma -p 3999 test/dummy/config.ru   # the gallery — visual validation
gem build phlex_kit.gemspec
```

Regenerate the CSS manifest after adding/removing any component CSS:

```ruby
m = "app/assets/stylesheets/phlex_kit/phlex_kit.css"
header = File.read(m)[/\A.*?\n(?=@import)/m]
lines = Dir.glob("app/components/phlex_kit/*/*.css").sort.map { |c| %(@import url("#{c.sub("app/components/phlex_kit/", "")}");) }
File.write(m, header + %(@import url("_tokens.css");\n) + lines.join("\n") + "\n")
```

## Non-negotiable conventions

- One folder per component under `app/components/phlex_kit/<name>/`, one file
  per constant, co-located `<name>.css` AND co-located `<name>_controller.js`
  (the component's Stimulus controller lives beside its `.rb`/`.css`). Zeitwerk
  collapse makes `button/button.rb` → `PhlexKit::Button` (flat constants — parts
  like `card/card_header.rb` are `PhlexKit::CardHeader`); Zeitwerk ignores the
  `.js`.
- Root element: `**mix({ class: ..., data: ... }, @attrs)` so caller attrs
  (including a phlex-reactive `**on(:event)` bundle) pass through. Variant
  maps use `VARIANTS.fetch` — fail loud, never `[]`.
- CSS: `.pk-<name>[-part]` classes + bare-word modifiers; colors ONLY via
  `--pk-*` tokens (`_tokens.css` mirrors ui.shadcn.com's live values — hover
  fills use `--pk-accent`, control borders `--pk-input`, focus rings
  `box-shadow: 0 0 0 3px color-mix(in oklab, var(--pk-ring) 50%, transparent)`).
  All radii derive from `--pk-radius` (`calc(var(--pk-radius) - 2px)` etc);
  default is 0.625rem/10px — tokenize literals with a calc offset that keeps
  the default rendering identical (`.75rem` → `calc(var(--pk-radius) + 2px)`).
  Shadows/overlays use `color-mix(in srgb, var(--pk-shadow-color|--pk-overlay)
  N%, transparent)` — never hardcoded blacks. Direction-relative properties use
  logical equivalents (`inset-inline-*`, `text-align: start`); physical only
  for side-kwarg contracts (sheet/drawer/toast positions) and centering math.
- Clone-based modals (alert_dialog, sheet/drawer, sidebar mobile, command
  dialog) `inert` the page behind them — restore on close, disconnect, AND
  `turbo:before-cache`; the helper is duplicated per controller by design (no
  shared JS util). The before-cache rule is universal: ANY transient UI (open
  dialog, flash popover, toast) must clear on `turbo:before-cache` — Turbo
  snapshots BEFORE disconnect, so a missed listener resurrects the overlay
  from the page cache (bit dialog and clipboard). Viewport-scoped overlays
  (sidebar's mobile drawer) also need a matchMedia change listener to close
  on breakpoint crossing, or their inert marks outlive the CSS showing them.
- JS: Stimulus only, identifiers `phlex-kit--<name>`, data keys
  `phlex_kit__<name>_target`. The controller file lives in the component folder
  (`app/components/phlex_kit/<name>/<name>_controller.js`) but keeps the flat
  `phlex_kit/controllers/<name>_controller` module id — `config/importmap.rb`
  globs the component folders and re-pins each under that stable namespace, so
  the central registry and host API never change. Register every controller in
  the central `app/javascript/phlex_kit/controllers/index.js` (imports AND
  `application.register`, both sorted); `javascript_registration_test.rb` guards
  that every co-located controller is imported + registered.
  Floating panels are native `[popover]` elements with CSS anchor positioning
  (`position-try-fallbacks` flips at viewport edges; gate `display` on
  `:popover-open`; UA `overflow:auto` clips bridge pseudos — restate visible);
  non-floating show/hide toggles the `.pk-hidden` utility. No npm deps —
  floating-ui → anchor positioning, embla → translate engine, fuse → substring/fuzzy scorer,
  vaul → sheet clone machinery, chart.js → host-supplied `window.Chart`.
- Attribution comment on each lead class (`# … ported from ruby_ui's X` /
  `# … ported from shadcn/ui's X`).
- Every component: render test in `test/components/`, CSS in the manifest,
  gallery section in `test/dummy/app/components/gallery/page.rb`.

## Gotchas that have already bitten

- **Inline `style:` strings must end with `;`** — Phlex `mix` joins duplicate
  string attrs with a space, so `style: "flex-grow: 30"` + caller
  `style: "color: red"` fuses into one invalid declaration that kills BOTH
  (bit aspect_ratio, slider, resizable_panel, sheet/dialog close wrappers).
- **`mix` merges duplicate attrs, never overrides** — any attribute a
  component generates itself (id, style, aria-*) must be a named kwarg, or a
  caller's copy fuses into one invalid two-token value (bit SelectContent's
  generated id, breaking aria-controls).
- **System tests (Cuprite)**: use the raw-keyboard `press` helper from
  `test/system/interaction_helpers.rb` — element `send_keys` prefixes a click
  that activates focused menu items. Native `<dialog>` fires `close` as a
  queued task — poll with `wait_until`, never read scroll-lock state
  synchronously after closing. No `sleep`s; every visit installs a JS-error
  trap that flunks the test in teardown. The dummy app runs no Turbo — test
  before-cache behavior by dispatching `new Event("turbo:before-cache")` on
  document. Assert timer-adjacent state synchronously via `evaluate_script`
  (`assert_no_selector`'s wait lets a 1.5s auto-hide mask a missing
  listener). Breakpoint tests: `page.driver.resize(w, h)` — restore the
  1400×900 default in teardown.
  Cuprite node refs go stale (`ObsoleteNode`) after a detach/reattach —
  drive those flows via `execute_script` on selectors, not held elements.
  The Cuprite driver pins `blink-settings` hover/pointer capabilities —
  headless Chrome on CI Linux has no pointing device and reports
  `hover: none`, so `@media (hover: hover)` rules never match there
  (bit the tooltip WCAG-hoverable test: green locally, red on CI).
  Detach+reattach of a controller root re-runs `connect()` on markup still
  carrying snapshot-stale attributes — the standard way to simulate a Turbo
  cache restore (see audit6_turbo_state_system_test). Stimulus
  `[target]Connected` fires async after a DOM insert — poll with
  `wait_until`, never read the effect synchronously. Synthetic pointer/click
  events aimed at dialog backdrop logic need `detail: 1` (detail 0 is
  treated as keyboard/synthetic and ignored).
- **Manifest imports must be relative to the manifest's own directory**
  (`_tokens.css`, `button/button.css` — never `phlex_kit/…`): Propshaft
  resolves bare `url()` paths against the referencing file's dir, so a
  prefixed path doubles up and 404s. Only the `url("…")` form is
  fingerprinted. `manifest_test.rb` guards both.
- **Stimulus target getters throw when absent** — `this.fooTarget?.x` never
  guards anything; use `hasFooTarget` (bit message_scroller's history
  prepend).
- **`data-state` is the CSS styling hook** — server-render it on stateful
  parts (`active:` etc.) AND make `connect()` honor server-marked state
  instead of forcing a default (bit tabs: active trigger unstyled pre-JS,
  then overridden by hydration).
- **Stimulus fires `[target]Connected` before `connect()`** — state used by
  target callbacks must be initialized in `initialize()` (bit the toaster
  with server-rendered flash toasts).
- **The unit suite cannot nest `render`** — `RenderHelper#render` returns a
  string, so composing components inside a test block escapes the child HTML.
  Render multi-part components part-by-part in tests; compose only in the
  gallery.
- The kit-wide `box-sizing: border-box` rule lives in `_tokens.css`, scoped
  to `pk-*` classes; `width: 100%` + padding without it overflows containers.
- Hover-opened panels need an invisible `::before` bridge over the
  trigger→panel gap or `mouseleave` closes them mid-travel (menubar/nav menu).
- Standalone (non-Rails) requires live in `lib/phlex_kit.rb` (`json`,
  `securerandom`, `cgi`) — components must load without a booted Rails app;
  the test suite depends on it.
- The engine must keep `app/components`, `app/assets/stylesheets`, AND
  `app/javascript` on the asset path. Co-located `*_controller.js` files are
  served via `app/components`; `app/javascript` still serves the central
  `controllers/index.js` — dropping it silently kills the `phlex_kit/controllers`
  registry pin.
- **Stale importmap cache**: after moving/adding a controller, `test/dummy` can
  serve a cached importmap (only 3 pins instead of all of them). Delete
  `test/dummy/tmp/cache` and restart puma to force a fresh draw.
- Gallery JS errors surface in an on-page red banner (screenshot-reviewable);
  the dummy app vendors Stimulus and Chart.js under
  `test/dummy/vendor/javascript/`.
- **The kit's border-box reset is `pk-*`-scoped by design** — page-level
  chrome (docs `.docs-*`, examples `.adm-*`) needs its own scoped
  `box-sizing: border-box` rule or `width: 100%` + padding overflows at
  narrow widths (bit the Harbor settings page at 700px).
- **Flex children of a height-constrained scroll pane need `flex: none`**
  or they silently squash instead of overflowing into scroll (bit the
  inbox detail pane — cards shrank to their headers).
- **Custom-property cascade trap**: a `--pk-*` token set only in the dark
  `:root` block leaks into light mode — `var()` fallbacks apply to *unset*
  properties only, and `:root` values cascade into `:root[data-theme="light"]`.
  Any mode-varying token (incl. the optional `--pk-sidebar-*` overrides) must
  be restated in BOTH light blocks (bit the neutral theme's blue
  sidebar-primary).
- **Known RTL limitations (deliberate, audit round 5)**: sidebar is
  physically left-pinned (no `side:` kwarg yet) and resizable's drag math
  assumes LTR (commented at the clientX delta) — these two remain the only
  deliberate exemptions. Everything else uses logical
  properties — keep it that way; physical is only for the side-kwarg
  contracts (sheet/drawer/toast) and centering math. Round 6 made carousel
  (direction-aware geometry + keyNext/keyPrev), switch/slider/progress
  (`:dir(rtl)` arms) and hover_card/dropdown/select (logical gap
  margins/paddings) RTL-correct — new work must not regress them. Round 7
  added the RTL keyboard cluster: tabs/toggle_group (horizontal arrows flip,
  Up/Down don't), calendar (ArrowLeft/Right day delta flips, week/Page/Home/
  End don't), and dropdown/context/menubar (submenu enter/exit keys +
  menubar bar traversal follow visual direction — panels open inline-end =
  visually LEFT in RTL, so ArrowLeft enters). All use a runtime
  `getComputedStyle(this.element).direction === "rtl"` check (reliable after
  a dynamic flip, unlike CSS `:dir()`); sub-trigger chevrons mirror via a
  `[dir="rtl"] .pk-…-sub-chevron { transform: scaleX(-1) }` ancestor arm
  (attribute selectors re-style on a dynamic flip; `:dir()` would not).
  Gate: audit7_rtl_keyboard_system_test.
- **Chrome doesn't re-style `:dir()` on a dynamic `dir` flip** — existing
  elements keep the old evaluation inside `:dir()`-compound selectors until
  they're reattached, even though `el.matches(":dir(rtl)")` says true. Pages
  that LOAD as RTL are fine. In browser probes, detach/reattach after
  flipping `document.dir`; the Cuprite RTL system tests are the real gate.
- **Generated attrs must be named kwargs** (round 6, extends the `mix`-merge
  rule): TabsTrigger/TabsContent/ComboboxList/CommandList/FormFieldError/
  FormFieldHint ids, Marker `type:`, Progress `value_text:`, Pagination
  `label:` — a caller copy would fuse. For generated *defaults* the caller
  may override (icon width/aria-hidden, scroll_area role/tabindex, codeblock/
  chart aria-label), check `@attrs` first (`BaseComponent#aria_labelled?`).
- **`open:` values are one-shot** on clone-based overlays (alert_dialog,
  sheet): clear `openValue` when the clone spawns, or the reflected value in
  the Turbo snapshot re-opens a dismissed overlay on restore. Popover-based
  menus close on `turbo:before-cache` (dropdown/context) or normalize stale
  `aria-expanded`/`aria-activedescendant` in `connect()` (select/combobox/
  menubar) — a snapshot serializes those even though `:popover-open` dies.
- **"backspace" is NOT a Stimulus key filter** — `keydown.backspace->` throws
  "unknown key filter" on every keystroke and the action never runs (bit the
  combobox badge chips). Bind bare `keydown` and guard `e.key` in the method.
- **The system-test JS-error trap needs BOTH halves** (round 6): Cuprite's
  `Runtime.evaluate` must pass `returnByValue: true` (arrays come back as
  remote references, so the trap silently never flunked), and Stimulus
  catches action-handler exceptions and reports via `console.error` — the
  trap hooks it; `window.onerror` alone misses them.
- **ToastRegion `theme:`/`rich_colors:` raise by design** — tokens are
  :root-scoped and the kit has no status palette; don't "implement" them
  casually. `offset:` is `--pk-toast-offset`; `dir:` is a real dir attribute;
  pause/resume events are dispatched on the region's own list, not document.
- **macOS Option-chords compose `e.key`** (Option+T → "†") — hotkey matching
  must accept `e.code` (`KeyT`) or alt+ hotkeys never fire on Mac.

## Releasing

1. Bump `lib/phlex_kit/version.rb`, run the suite, commit, push.
2. `git tag -a vX.Y.Z && git push origin vX.Y.Z`; `gem build phlex_kit.gemspec`;
   `gh release create vX.Y.Z phlex_kit-X.Y.Z.gem --title … --notes …`.
3. rubygems publish is interactive (MFA) — the user runs
   `gem push phlex_kit-X.Y.Z.gem --otp <code>` in their own terminal.
   Credentials live at `~/.local/share/gem/credentials` (XDG path); the API
   key needs the *push rubygem* scope and must not be gem-scoped for a
   first-time push.

CI (`.github/workflows/ci.yml`) runs lint + suite + a gem-contents assertion
on Ruby 3.2/3.3/3.4/4.0. Keep it green before tagging.
