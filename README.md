# PhlexKit

A [ruby_ui](https://ruby-ui.com)-style component kit for [Phlex](https://phlex.fun),
styled with **vanilla CSS + design tokens instead of Tailwind**, and built so
[phlex-reactive](https://github.com/mhenrixon/phlex-reactive) is an *optional,
per-component* integration — never a required dependency.

- **No build step.** Components ship as plain Ruby classes with co-located vanilla
  CSS. No Tailwind, no Node, no PostCSS. Assets are precompiled-static in the gem.
- **Theme with CSS custom properties.** Every component reads `--pk-*` tokens via
  `var()` + `color-mix()`. Redefine `:root` and the whole kit re-themes live —
  including dark/light/system — with no rebuild.
- **Reactive when you want it.** Components pass `**attrs` straight through Phlex's
  `mix`, so a phlex-reactive `**on(:event)` bundle composes onto the root element
  with zero coupling. Non-reactive components never touch phlex-reactive.

## Install

```ruby
# Gemfile
gem "phlex_kit"
```

```bash
bundle install
bin/rails g phlex_kit:install
```

The installer adds `@import url("phlex_kit/phlex_kit.css");` to your
`application.css`, drops `config/initializers/phlex_kit.rb`, and prints the
Stimulus wiring. That's it — no Tailwind config, no content globs.

## Usage

```ruby
render PhlexKit::Button.new(variant: :primary, size: :lg) { "Save changes" }

render PhlexKit::Card.new do
  render PhlexKit::CardHeader.new do
    render PhlexKit::CardTitle.new { "Team" }
  end
  render PhlexKit::CardContent.new { "…" }
end

render PhlexKit::Badge.new(variant: :success) { "Live" }
```

Prefer revue-style `UI::Button`? Turn on the alias in the initializer:

```ruby
PhlexKit.configure { |c| c.define_ui_alias = true }   # UI == PhlexKit
```

## Theming

The gem ships a default dark/light/system token set (`_tokens.css`). Override any
token in your own stylesheet — your app's CSS sorts ahead of the gem's, so you win:

```css
@import url("phlex_kit/phlex_kit.css");

:root {
  --pk-brand: #3b5bdb;
  --pk-radius: 6px;
}
```

Want a completely custom palette? Delete the `_tokens` import line from your
manifest and define the `--pk-*` properties yourself. Every component has a
literal fallback in `var(--pk-*, …)`, so nothing breaks if a token is missing.

## Interactive components (Stimulus)

Dialog, Dropdown, Select, and Avatar ship plain Stimulus controllers (no
phlex-reactive needed). Register them once in your Stimulus entrypoint:

```js
import { registerPhlexKitControllers } from "phlex_kit/controllers"
registerPhlexKitControllers(application)
```

## phlex-reactive (optional)

For components that own server-state behavior (live counters, moderation queues,
cross-tab updates), add phlex-reactive and include its mixin in a component:

```ruby
# Gemfile
gem "phlex-reactive"
```

```ruby
class MyCounter < PhlexKit::BaseComponent
  include Phlex::Reactive::Component
  action(:increment) { @count += 1 }
  # view_template uses **on(:increment) on a button — it just flows through mix
end
```

PhlexKit does **not** depend on phlex-reactive. `PhlexKit.reactive?` auto-detects
it; set `config.reactive` to force it on/off.

## Ejecting components (shadcn-style)

Want to own and edit a component's source? Eject it into your app:

```bash
bin/rails g phlex_kit:component button
```

This copies `button.rb` + `button.css` into `app/components/phlex_kit/button/`
and wires its `@import`. Your copy shadows the gem's.

## How the asset wiring works

Three engine initializers reproduce the pattern proven in production (revue):

1. `app/components` and the stylesheet dir go on Propshaft's load path so CSS can
   sit beside each `.rb`.
2. Component folders are Zeitwerk-`collapse`d, so `button/button.rb` is
   `PhlexKit::Button` (not `PhlexKit::Button::Button`) and `card/card_header.rb`
   is `PhlexKit::CardHeader`.
3. A private-method guard keeps Propshaft from serving Ruby source out of
   `public/assets/` (covered by `test/assets/asset_load_path_test.rb`).

Only the `@import url("…")` form is fingerprinted by Propshaft — a bare
`@import "…"` ships un-digested and 404s. The manifest always uses `url()`.

## Components

See [ROADMAP.md](ROADMAP.md) for the full inventory and porting status.

## License

MIT.
