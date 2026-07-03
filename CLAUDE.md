# CLAUDE.md — phlex_kit

Phlex + Rails component kit: the full ruby_ui catalog + shadcn/ui's additions
(70 component families), vanilla CSS on `--pk-*` tokens, `@hotwired/stimulus`
only. Published to rubygems.org as `phlex_kit`. Read `docs/03-SPEC.md` for the
architecture; `ROADMAP.md` for the inventory; this file for how to work here.

## Commands

```bash
bundle exec rake test                 # full suite (fast, no Rails boot)
node --check app/javascript/phlex_kit/controllers/<name>_controller.js
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
  per constant, co-located `<name>.css`. Zeitwerk collapse makes
  `button/button.rb` → `PhlexKit::Button` (flat constants — parts like
  `card/card_header.rb` are `PhlexKit::CardHeader`).
- Root element: `**mix({ class: ..., data: ... }, @attrs)` so caller attrs
  (including a phlex-reactive `**on(:event)` bundle) pass through. Variant
  maps use `VARIANTS.fetch` — fail loud, never `[]`.
- CSS: `.pk-<name>[-part]` classes + bare-word modifiers; colors ONLY via
  `--pk-*` tokens (`_tokens.css` mirrors ui.shadcn.com's live values — hover
  fills use `--pk-accent`, control borders `--pk-input`, focus rings
  `box-shadow: 0 0 0 3px color-mix(in oklab, var(--pk-ring) 50%, transparent)`).
  All radii derive from `--pk-radius` (`calc(var(--pk-radius) - 2px)` etc).
- JS: Stimulus only, identifiers `phlex-kit--<name>`, data keys
  `phlex_kit__<name>_target`. Register every controller in
  `controllers/index.js` (imports AND `application.register`, both sorted).
  Show/hide toggles the `.pk-hidden` utility. No npm deps — floating-ui →
  CSS positioning, embla → translate engine, fuse → substring/fuzzy scorer,
  vaul → sheet clone machinery, chart.js → host-supplied `window.Chart`.
- Attribution comment on each lead class (`# … ported from ruby_ui's X` /
  `# … ported from shadcn/ui's X`).
- Every component: render test in `test/components/`, CSS in the manifest,
  gallery section in `test/dummy/app/components/gallery/page.rb`.

## Gotchas that have already bitten

- **Manifest imports must be relative to the manifest's own directory**
  (`_tokens.css`, `button/button.css` — never `phlex_kit/…`): Propshaft
  resolves bare `url()` paths against the referencing file's dir, so a
  prefixed path doubles up and 404s. Only the `url("…")` form is
  fingerprinted. `manifest_test.rb` guards both.
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
  `app/javascript` on the asset path — dropping the last silently kills every
  importmap controller pin.
- Gallery JS errors surface in an on-page red banner (screenshot-reviewable);
  the dummy app vendors Stimulus and Chart.js under
  `test/dummy/vendor/javascript/`.
- **Custom-property cascade trap**: a `--pk-*` token set only in the dark
  `:root` block leaks into light mode — `var()` fallbacks apply to *unset*
  properties only, and `:root` values cascade into `:root[data-theme="light"]`.
  Any mode-varying token (incl. the optional `--pk-sidebar-*` overrides) must
  be restated in BOTH light blocks (bit the neutral theme's blue
  sidebar-primary).

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
