# PhlexKit

[![Gem Version](https://img.shields.io/gem/v/phlex_kit)](https://rubygems.org/gems/phlex_kit)
[![CI](https://github.com/MatthewKennedy/phlex_kit/actions/workflows/ci.yml/badge.svg)](https://github.com/MatthewKennedy/phlex_kit/actions/workflows/ci.yml)

A [shadcn/ui](https://ui.shadcn.com)-grade component kit for
[Phlex](https://phlex.fun) + Rails, styled with **vanilla CSS + design tokens
instead of Tailwind**. The full [ruby_ui](https://ruby-ui.com) catalog plus
shadcn's own additions — 70 component families, 38 Stimulus controllers —
with the default theme lifted verbatim from shadcn/ui's current token system.

- **No build step.** Components are plain Ruby classes with co-located vanilla
  CSS, served precompiled-static through Propshaft. No Tailwind, no Node, no
  PostCSS.
- **The shadcn look, themeable.** Every component reads `--pk-*` custom
  properties. The default palette, radii, and control geometry match
  ui.shadcn.com; redefine `:root` and the whole kit re-themes live — dark,
  light, and system included.
- **`@hotwired/stimulus` only.** Every interactive component works with one
  registration call. The JS dependencies the upstream kits lean on
  (floating-ui, embla, fuse.js, vaul, Radix, chart.js, …) are all replaced
  with small vanilla equivalents — or, for charts, left to the host.
- **Reactive when you want it.** Components pass `**attrs` straight through
  Phlex's `mix`, so a [phlex-reactive](https://github.com/mhenrixon/phlex-reactive)
  `**on(:event)` bundle composes onto the root element with zero coupling.

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
Stimulus wiring. Then register the controllers once in your Stimulus
entrypoint:

```js
// app/javascript/application.js
import { Application } from "@hotwired/stimulus"
import { registerPhlexKitControllers } from "phlex_kit/controllers"

const application = Application.start()
registerPhlexKitControllers(application)
```

That's it — no Tailwind config, no content globs, no bundler.

## Usage

```ruby
render PhlexKit::Button.new(variant: :primary, size: :lg) { "Save changes" }

render PhlexKit::Card.new do
  render PhlexKit::CardHeader.new do
    render PhlexKit::CardTitle.new { "Team" }
    render PhlexKit::CardDescription.new { "Invite and manage members." }
  end
  render PhlexKit::CardContent.new { "…" }
end

render PhlexKit::Badge.new(variant: :secondary) { "Live" }
```

A form field with client-side live validation (fills the error once the
browser flags the control invalid, clears it as the user types):

```ruby
render PhlexKit::Form.new(action: "/users", method: "post") do
  render PhlexKit::FormField.new do
    render PhlexKit::FormFieldLabel.new(for: "email") { "Email" }
    render PhlexKit::Input.new(
      type: :email, id: "email", name: "email", required: true,
      data: { value_missing: "Email is required." }
    )
    render PhlexKit::FormFieldError.new
  end
  div(class: "pk-form-actions") do
    render PhlexKit::Button.new(type: :submit) { "Create account" }
  end
end
```

A toast, spawned from anywhere (mount `PhlexKit::ToastRegion.new(flash: flash)`
once at the end of `<body>` — server flash messages render as toasts too):

```js
PhlexKit.toast.success("Saved", { description: "Your changes are live." })
```

Prefer `UI::Button`? Turn on the alias in the initializer:

```ruby
PhlexKit.configure { |c| c.define_ui_alias = true }   # UI == PhlexKit
```

## Theming

The gem ships shadcn/ui's default (neutral) token set — dark by default, light
via `<html data-theme="light">`, OS-following via `data-theme="system"`.
Override any token in your own stylesheet; your app's CSS sorts ahead of the
gem's, so you win:

```css
@import url("phlex_kit/phlex_kit.css");

:root {
  --pk-brand: #3b5bdb;      /* primary buttons, selected states, slider fill */
  --pk-radius: 0.375rem;    /* every component radius derives from this */
}
```

The full token surface: `--pk-bg`, `--pk-surface`, `--pk-surface-2`,
`--pk-accent` (hover fills), `--pk-border`, `--pk-input` (control borders),
`--pk-ring` (focus rings), `--pk-text`, `--pk-text-2`, `--pk-muted`,
`--pk-brand`, `--pk-brand-ink`, `--pk-green`, `--pk-amber`, `--pk-red`,
`--pk-chart-1..5`, `--pk-radius`. Want a fully custom palette? Drop the
`_tokens.css` import and define them all yourself.

## Charts

`PhlexKit::Chart` is deliberately a thin wrapper — **no charting library is
bundled**. Expose [Chart.js](https://www.chartjs.org) as `window.Chart` (a
vendored UMD file and one `javascript_include_tag` is enough) and the kit
builds the chart with shadcn-style theming: series colored from
`--pk-chart-1..5`, translucent area fills, hairline grids, re-rendering on
theme change.

```ruby
render PhlexKit::Chart.new(options: {
  type: "line",
  data: { labels: %w[Jan Feb Mar], datasets: [ { label: "Orders", data: [3, 7, 4], fill: true } ] }
})
```

No `window.Chart`? The controller dispatches `phlex-kit--chart:connect` with
`{ canvas, options }` so you can drive any other library.

## phlex-reactive (optional)

For components that own server-state behavior, add phlex-reactive and include
its mixin — PhlexKit does **not** depend on it:

```ruby
class MyCounter < PhlexKit::BaseComponent
  include Phlex::Reactive::Component
  action(:increment) { @count += 1 }
  # view_template uses **on(:increment) on a button — it just flows through mix
end
```

`PhlexKit.reactive?` auto-detects the gem; set `config.reactive` to force it.

## Ejecting components (shadcn-style)

Want to own and edit a component's source? Eject it into your app:

```bash
bin/rails g phlex_kit:component button
```

This copies `button.rb` + `button.css` into `app/components/phlex_kit/button/`
and wires its `@import`. Your copy shadows the gem's.

## The gallery

A dummy Rails app renders every component on one page — useful as living
documentation and for eyeballing theme changes:

```bash
git clone https://github.com/MatthewKennedy/phlex_kit && cd phlex_kit
bundle install
bundle exec puma -p 3999 test/dummy/config.ru
# open http://127.0.0.1:3999
```

## Components

Everything in ruby_ui (53/53) plus shadcn/ui's own catalog: accordion, alert,
alert dialog, aspect ratio, attachment, avatar (+ group), badge, breadcrumb,
bubble, button, button group, calendar, card, carousel, chart, checkbox,
clipboard, codeblock, collapsible, combobox (button/input/badge-chip
triggers), command palette, context menu, data table, date picker, dialog,
drawer, dropdown menu, empty, form + form field, hover card, input, input
group, input OTP, item, kbd, label, link, masked input, menubar, message,
message scroller, native select, navigation menu, pagination, popover,
progress, radio button + radio group, resizable, scroll area, select,
separator, sheet, shortcut key, sidebar, skeleton, slider, spinner, stars,
switch, table, tabs, textarea, theme toggle, toast (sonner-style), toggle,
toggle group, tooltip, typography.

Inventory and porting notes: [ROADMAP.md](ROADMAP.md). Architecture and
conventions: [docs/](docs/).

## How the asset wiring works

Four engine initializers make the zero-build story hold:

1. `app/components`, the stylesheet dir, and `app/javascript` go on
   Propshaft's load path, so CSS sits beside each `.rb` and the importmap pins
   resolve.
2. Component folders are Zeitwerk-`collapse`d, so `button/button.rb` is
   `PhlexKit::Button` and `card/card_header.rb` is `PhlexKit::CardHeader`.
3. A guard keeps Propshaft from serving Ruby source out of `public/assets/`.
4. The gem's importmap (pinning every controller) is appended to the host's.

Manifest imports use the `@import url("…")` form (Propshaft only fingerprints
`url()`) with paths relative to the manifest's own directory — both guarded by
tests.

## License

MIT. Component design ported from [ruby_ui](https://github.com/ruby-ui/ruby_ui)
and [shadcn/ui](https://ui.shadcn.com) (both MIT), with attribution comments
retained per component.
