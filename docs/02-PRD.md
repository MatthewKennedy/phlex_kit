# PhlexKit — Product Requirements Document

**Owner:** Matt Kennedy (Aypex) · **Status:** Draft for build handoff · **Date:** 2026-07-02

## 1. Summary

PhlexKit is a Ruby gem: a component library for [Phlex](https://phlex.fun) that ports
the full [ruby_ui](https://ruby-ui.com) catalog, but replaces Tailwind with
**co-located vanilla CSS per component** and a **global `--pk-*` design-token theme**.
[phlex-reactive](https://github.com/mhenrixon/phlex-reactive) is supported as an
**optional, per-component** integration — never a required dependency.

A working reference implementation (45 of 53 components, all render-tested) lives at
`~/Developer/phlex_kit`. This PRD + the accompanying [SPEC](03-SPEC.md) define the
product so the remaining work can be completed and the whole polished.

## 2. Problem & motivation

- ruby_ui is excellent but **Tailwind-coupled**: consuming it in a gem means the host
  app must run a Tailwind build (Node toolchain, content globs, purge config). Many
  Rails 8 apps are importmap-only with no Node.
- Teams (e.g. Aypex's `revue`) already hand-port ruby_ui components to vanilla CSS +
  design tokens. That pattern deserves to be a **reusable, versioned gem** rather than
  copy-pasted per project.
- phlex-reactive offers a compelling server-driven reactivity story, but is too young
  to hard-depend on — the library must remain useful and complete without it.

## 3. Goals

- **G1 — Full parity:** port all 53 ruby_ui components to Phlex.
- **G2 — Zero build step:** ship precompiled-static vanilla CSS; no Tailwind, Node, or
  PostCSS required in the host.
- **G3 — Token theming:** every component reads `--pk-*` custom properties; hosts
  re-theme (incl. dark/light/system) by redefining `:root`, no rebuild.
- **G4 — Reactivity optional:** components compose with phlex-reactive via attribute
  pass-through, but the gem does not depend on it.
- **G5 — Dual distribution:** usable as a required gem (versioned upgrades) *and* as
  shadcn-style copy-in components (ejectable source).
- **G6 — Accessible & faithful:** preserve ruby_ui's DOM structure, ARIA roles, and
  keyboard behavior.

## 4. Non-goals

- **NG1** — Not a Tailwind theme or plugin.
- **NG2** — No bundled heavy JS dependencies by default (see §7 decisions).
- **NG3** — Not a full application framework; it is a view-component kit.
- **NG4** — Not tied to any one Aypex app (revue is the origin, not the constraint).

## 5. Users

- **Primary:** Rails + Phlex developers who want shadcn-quality components without a
  Tailwind pipeline.
- **Secondary:** teams already on ruby_ui who want a vanilla-CSS, token-themed variant.
- **Internal:** Aypex apps (revue and future products) adopting a shared kit.

## 6. Requirements

### Functional
- **F1** — 53 components with ruby_ui-equivalent public APIs (`variant:`/`size:`/slots).
- **F2** — Each component: one folder `app/components/phlex_kit/<name>/` holding its
  `.rb` part(s) + co-located `.css`.
- **F3** — A single manifest stylesheet the host imports with one `@import url(...)` line.
- **F4** — A default `--pk-*` token theme (dark/light/system) that hosts can override or
  replace.
- **F5** — Interactive components ship Stimulus controllers registered under
  `phlex-kit--*` identifiers via one `registerPhlexKitControllers(app)` call.
- **F6** — `rails g phlex_kit:install` (wire manifest + initializer) and
  `rails g phlex_kit:component <name>` (eject a component's source into the host).
- **F7** — Optional phlex-reactive: a component can `include Phlex::Reactive::Component`
  when present; `on(...)` is a safe no-op otherwise.

### Non-functional
- **NF1** — No host build step; CSS ships fingerprinted-static via Propshaft.
- **NF2** — Runtime deps limited to `phlex-rails` and `railties`. No `tailwind_merge`.
- **NF3** — Ruby ≥ 3.2; Rails 7.1–8.x; Propshaft (primary). MIT licensed, with
  attribution to ruby_ui retained in ported components.
- **NF4** — Every component render-tested; asset-wiring guarded by tests (manifest
  completeness, `url()` form, Propshaft source-skip).
- **NF5** — Accessibility parity with ruby_ui (roles, aria, keyboard nav).

## 7. Key decisions (locked)

| Decision | Choice |
|---|---|
| Name / module | **PhlexKit** / `PhlexKit::` |
| CSS class prefix | `.pk-*` |
| Token prefix | `--pk-*` (with literal fallbacks in `var()`) |
| Scope | **All 53 components** |
| phlex-reactive | Optional, per-component; not a runtime dep |
| Positioning (popover/hover_card/context_menu/combobox) | **CSS positioning**, no `@floating-ui` |
| codeblock highlighting | **Plain** (no `rouge`); host may add it |
| chart | Thin wrapper; **no bundled charting lib** (host-supplied) |
| masked_input | Small **dependency-free** mask (no `maska`) |
| Distribution | Dual: require-the-gem **and** copy-in generator |

## 8. Success criteria

- All 53 components implemented, each with a co-located CSS file listed in the manifest.
- `bundle exec rake test` green; the built `.gem` contains the CSS assets.
- A host app can: add the gem, run the installer, render `PhlexKit::Button.new(...)`,
  and re-theme by redefining `--pk-*` — with **no Node/Tailwind build**.
- Interactive components function with only `@hotwired/stimulus` registered.

## 9. Status & remaining scope

**Built & tested (53/53 — full parity, complete 2026-07-02):** accordion, alert,
alert_dialog, aspect_ratio, avatar, badge, breadcrumb, bubble, button, calendar, card,
carousel, chart, checkbox, clipboard, codeblock, collapsible, combobox, command,
context_menu, data_table, date_picker, dialog, dropdown_menu, empty, form (+
form_field with live validation), hover_card, input, link, masked_input, message,
message_scroller, native_select, pagination, popover, progress, radio_button, select,
separator, sheet, shortcut_key, sidebar, skeleton, switch, table, tabs, textarea,
theme_toggle*, toast, toggle, toggle_group, tooltip, typography. (*+ a `stars` extra
not in ruby_ui.)

All §7 dependency decisions held: no `@floating-ui` (CSS positioning), no bundled
charting lib (`chart` is a thin wrapper — `window.Chart` if the host ships it, else a
`phlex-kit--chart:connect` event), no `rouge`, no `maska`; additionally
`embla-carousel`, `fuse.js` and `mustache` were replaced with small vanilla
equivalents in the ported controllers. One deliberate omission: combobox's
input/badge trigger variants are unfinished upstream (their controller actions don't
exist in ruby_ui's own controller) and were not ported.

## 10. Open questions

- Confirm the three dependency decisions in §7 (codeblock/rouge, chart/lib,
  positioning) — defaults chosen to keep the gem dependency-free.
- Copy-in vs require-the-gem as the *documented default* adoption path.
- Whether `stars` stays (useful) or is dropped (not in ruby_ui).
