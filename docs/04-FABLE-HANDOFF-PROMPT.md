# PhlexKit — Fable Handoff Prompt

Paste the block below to Fable (run it from inside `~/Developer/phlex_kit`). It is
self-contained but references the three companion docs and the working prototype.

---

You are completing **PhlexKit**, a Ruby gem at `~/Developer/phlex_kit`: a Phlex
component library that ports the [ruby_ui](https://github.com/ruby-ui/ruby_ui) (MIT)
catalog, replacing Tailwind with **co-located vanilla CSS + `--pk-*` design tokens**,
with **phlex-reactive as an optional, per-component** integration (never a runtime dep).

**45 of 53 components are already built and render-tested.** Your job is to finish the
remaining 8 + one upgrade, to the exact conventions of the existing code, and keep the
test suite green.

## Read first (in this order)
1. `docs/02-PRD.md` — goals, non-goals, locked decisions.
2. `docs/03-SPEC.md` — architecture, naming, CSS/token map, JS rules, and **§9
   per-component guidance for exactly what you're building.**
3. The prototype as canonical examples of every pattern:
   - Variant component: `app/components/phlex_kit/button/button.rb` + `button.css`
   - Multi-part + Stimulus: `app/components/phlex_kit/dropdown_menu/*`, `dialog/*`, `tabs/*`
   - Controllers: `app/javascript/phlex_kit/controllers/*` + `index.js`
   - Tokens/manifest: `app/assets/stylesheets/phlex_kit/{_tokens,phlex_kit}.css`
4. ruby_ui source to port from: clone `github.com/ruby-ui/ruby_ui`; components live in
   `gem/lib/ruby_ui/<name>/` (`*_docs.rb` files are demo views — ignore them).

## Build these (see SPEC §9 for per-component notes)
`toast`, `combobox`, `command`, `carousel`, `calendar`, `date_picker`, `data_table`,
`chart`, and upgrade `form_field` → full `form`.

**Suggested order** (dependencies first): toast → carousel → combobox → command →
calendar → date_picker (needs calendar) → data_table → chart → form.

## Rules (non-negotiable — they define "consistent with the codebase")
- `module PhlexKit; class <Name> < BaseComponent`. One folder per component
  `app/components/phlex_kit/<name>/`, one file per constant (Zeitwerk-collapsed →
  flat constants). Co-locate `<name>.css`.
- Root element via `**mix({ class: classes }, @attrs)` so caller attrs (incl. a
  phlex-reactive `**on(:event)`) pass through. `VARIANTS.fetch` **fails loud**.
- Preserve ruby_ui's DOM structure, ARIA roles, `data-slot`s, and SVG icons.
- CSS: plain, `.pk-<name>[-part]` classes, **no Tailwind, no hardcoded colours** — map
  to `--pk-*` tokens using the table in SPEC §6; derive geometry from ruby_ui's Tailwind.
- JS: **`@hotwired/stimulus` only.** Controllers use `phlex-kit--<name>` identifiers and
  `phlex_kit__<name>_target` data keys. Replace ruby_ui's non-Stimulus imports:
  `@floating-ui/dom` → CSS positioning (like the shipped `select`/`popover`); `motion` →
  native `element.animate`; `maska` → the existing vanilla mask; `rouge` → omit. If a
  ruby_ui controller is already Stimulus-only (toast, carousel, calendar, data_table,
  form_field), copy it and rename `ruby-ui--`→`phlex-kit--`, `ruby_ui__`→`phlex_kit__`.
- For **chart**: ship a thin wrapper only — a container + a Stimulus hook reading
  `data-*`; do **not** bundle a charting library (document that the host supplies it).
- Keep an attribution comment on each lead class (`# … ported from ruby_ui's RubyUI::X`).
- **Do not** add gem deps (no `rouge`, `tailwind_merge`, charting gem) or npm deps.

## After each component
1. Register any controller in `app/javascript/phlex_kit/controllers/index.js`.
2. Regenerate the manifest (SPEC §6 snippet).
3. Add a render test in `test/components/` (class list, fail-loud, key wiring) — mirror
   `test/components/wave3_test.rb`.
4. Run `ruby -Ilib -Itest -e 'Dir["test/**/*_test.rb"].each { |f| require File.expand_path(f) }'`
   (or `bundle exec rake test`) — must stay **green**.
5. `node --check` any new `.js`.

## Acceptance criteria
- All 53 components implemented; each has a co-located CSS listed in the manifest.
- Full suite green; `gem build phlex_kit.gemspec` includes the CSS assets.
- Every interactive component works with only `@hotwired/stimulus` registered.
- `docs/02-PRD.md` §9 and `ROADMAP.md` updated to show 53/53.

## Guardrails
- ruby_ui is MIT — faithful porting with attribution is the task; keep transformations
  substantial (Tailwind→vanilla CSS, renamed identifiers, adapted controllers).
- If a component genuinely needs a decision (e.g. chart lib, or a behavior that can't be
  done without an external dep), stop and surface it rather than adding a dependency.
- Match the surrounding code's style, comment density, and idioms exactly.

---

*End of prompt. The remaining 8 are the heaviest in the catalog; expect toast,
data_table, and calendar/date_picker to be the largest. The 45 shipped components give
you a working example of every structural pattern you'll need.*
