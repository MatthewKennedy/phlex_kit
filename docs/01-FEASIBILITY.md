# PhlexKit — Feasibility Report

**Date:** 2026-07-02 · **Status:** Validated (a working 45/53 prototype exists at `~/Developer/phlex_kit`)

## Question

Is it feasible and worthwhile to build a Ruby gem — like [ruby_ui](https://ruby-ui.com)
but purpose-built for [phlex-reactive](https://github.com/mhenrixon/phlex-reactive) —
that ports **all** of ruby_ui's components to Phlex, replacing Tailwind with
**co-located vanilla CSS per component** plus a **global design-token stylesheet**?

## Verdict

**Feasible, and now demonstrated.** The approach was proven in miniature by the
`revue` app and has since been validated at scale: 45 of ruby_ui's 53 components
are ported and render-tested in the prototype. The one material risk is not the
CSS approach — it is the maturity of the youngest optional dependency,
phlex-reactive. Recommendation stands: **make phlex-reactive an optional,
per-component dependency, never a hard foundation.**

## Findings (adversarially verified — 23 of 25 claims confirmed)

### 1. phlex-reactive is real but very young
A genuine Livewire-style server-driven reactivity layer: actions are plain Ruby
methods (`action :name`), re-renders auto-target a component's stable id via Turbo
Streams, and a single generic Stimulus controller handles every reactive component.
It is a **mixin on a normal Phlex `ApplicationComponent`**, layered on standard
Phlex 2 / phlex-rails / Turbo 8 — so a plain Phlex port stays compatible with it.

But at research time it was **~12 days old, v0.4.8 (pre-1.0), ~23 stars, 0 forks,
single maintainer, ~3,700 downloads.** MIT. → Depend on it optionally, per component,
only where a component owns server-state behavior. *(Re-check these figures before
committing — they move fast.)*

### 2. ruby_ui is mature and MIT; ~53 components
Dual-distributed as a published gem (~80k downloads) **and** copy-in components,
built on Phlex `~> 2.1` + Tailwind + Stimulus. Its Tailwind coupling is **shallow**
(it depends on `tailwind_merge` purely to dedupe utility class strings), so styling
swaps cleanly to semantic classes + vanilla CSS while behavior is preserved — exactly
the translation performed here.

### 3. Vanilla CSS + design tokens is sound and mainstream
Tokens compile to native CSS custom properties on `:root` (the same mechanism Panda
CSS emits). Concrete wins for a *distributed gem*: **no build step / no Tailwind
toolchain dependency** (decisive — many Rails 8 apps are importmap-only, no Node),
**instant runtime theming + dark mode** by redefining `:root`, small self-contained
distribution, and per-component co-location.

### 4. Gem packaging is feasible via Propshaft
Propshaft (Rails 8 default) registers asset directories from gems into one load path
and auto-fingerprints `url()` references — which is why the manifest must use
`@import url("…")` (a bare `@import "…"` ships un-digested and 404s). App assets sort
ahead of gem assets, so hosts override theme tokens for free. The one discipline: a
gem must **ship precompiled-static CSS**, not rely on the host's build — which the
vanilla-CSS approach makes trivial.

## Risks & open questions

1. **phlex-reactive maturity** is the #1 risk. Keep it optional; provide a behavior
   abstraction so a component can use it *or* plain Stimulus.
2. **Not every component wants server round-trips.** Dialog, dropdown, popover,
   combobox, etc. are client-only UI state — plain Stimulus is the right default.
   (The prototype confirms this: 16 components ship plain Stimulus controllers; none
   require phlex-reactive.)
3. **Scale of vanilla CSS** across the full set — validated through 45 components; the
   remaining 8 are the heaviest (data_table, calendar, combobox, command, etc.).
4. **Distribution model** — copy-in vs require-the-gem. The prototype ships both.

## Two claims refuted (excluded)
- "Phlex has zero dependencies" (false — phlex-rails pulls a chain).
- "A gem exposes assets to both Sprockets and Propshaft with no per-pipeline logic"
  (over-broad).

## Key sources
- github.com/mhenrixon/phlex-reactive · phlex-reactive.zoolutions.llc
- ruby-ui.com · github.com/ruby-ui/ruby_ui (MIT)
- phlex.fun · github.com/rails/propshaft · panda-css.com/docs/theming/tokens
- github.com/sean-yeoh/shadcn_phlexcomponents (prior art)
