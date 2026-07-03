# PhlexKit — Propshaft + importmap install

A step-by-step guide to adding PhlexKit to a Rails app that uses the **default
asset stack** — Propshaft for assets and importmap-rails for JavaScript (no
Node, no bundler). This is the zero-build path the gem is designed for, and the
steps below are validated end-to-end against a fresh `rails new` app.

> **Scope.** This covers Propshaft + importmap (the Rails 7.1–8.x default). If
> your app uses jsbundling (esbuild/rollup/webpack) instead of importmap, the
> CSS steps are identical but you register the Stimulus controllers by importing
> from the gem in your bundle entrypoint rather than via the importmap pin — see
> [JavaScript](#4-register-the-stimulus-controllers) below.

## What you get

- Every component as a plain Ruby (Phlex) class — `render PhlexKit::Button.new …`.
- The full `--pk-*` token theme (shadcn/ui's default), dark/light/system.
- All interactive components working through **one** Stimulus registration call.
- No Tailwind, no PostCSS, no Node.

## Prerequisites

- Ruby ≥ 3.2, Rails 7.1–8.x.
- **Propshaft** (the default asset pipeline since Rails 8; `sprockets` also works).
- **importmap-rails** + **stimulus-rails** (the default `rails new` JS setup).
  A stock `rails new myapp` gives you exactly this.

---

## 1. Add the gem

```ruby
# Gemfile
gem "phlex_kit"
```

For local development against a checkout (what the maintainers use to validate a
release), point at the path instead:

```ruby
# Gemfile
gem "phlex_kit", path: "/path/to/phlex_kit"
```

Then:

```bash
bundle install
```

PhlexKit's only runtime dependencies are `phlex-rails` and `railties`; Bundler
pulls them in automatically.

## 2. Run the installer

```bash
bin/rails g phlex_kit:install
```

This does three things:

1. Creates `config/initializers/phlex_kit.rb` (theme/icon/alias config knobs).
2. Prepends `@import url("phlex_kit/phlex_kit.css");` to
   `app/assets/stylesheets/application.css` — an `@import` must precede every
   rule, hence the prepend.
3. Prints the Stimulus registration snippet (step 4).

That single `@import` pulls in the whole kit: it resolves through the engine's
Propshaft load path to the gem's manifest, which in turn imports `_tokens.css`
(the `--pk-*` theme) and every component's co-located CSS.

## 3. Confirm your layout links `application.css`

**In a stock Rails app you do not need to change anything here** — this section
is just to explain why it already works.

The default Rails 8 layout links the app stylesheet like this:

```erb
<%# app/views/layouts/application.html.erb %>
<%= stylesheet_link_tag :app, "data-turbo-track": "reload" %>
```

`stylesheet_link_tag :app` is Rails 8 sugar: the `:app` symbol maps to your
`app/assets/stylesheets/application.css` manifest (it renders
`/assets/application-<digest>.css`). There is no literal `app.css` — the helper
resolves the symbol to `application`. Since the installer put the PhlexKit
`@import` at the top of `application.css`, the kit's styles are served with **no
layout edit**.

If you have a **custom layout** that links some other manifest, make sure that
manifest carries the `@import` (or add it yourself). As an alternative to the
`@import`, you can link the gem's manifest directly:

```erb
<%= stylesheet_link_tag "phlex_kit/phlex_kit", "data-turbo-track": "reload" %>
```

## 4. Register the Stimulus controllers

The engine appends the gem's importmap to your host importmap, so the module
`phlex_kit/controllers` is available with no pin of your own. Register the kit's
controllers once, wherever your app starts Stimulus.

In a default importmap app, `app/javascript/controllers/index.js` already has a
Stimulus `application` — add two lines:

```js
// app/javascript/controllers/index.js
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

// PhlexKit: register the kit's Stimulus controllers.
import { registerPhlexKitControllers } from "phlex_kit/controllers"
registerPhlexKitControllers(application)
```

(If you wire Stimulus yourself, the shape is the same — call
`registerPhlexKitControllers(application)` on whatever `application` you
`Application.start()`.)

Static components (button, badge, card, …) need none of this — they're pure
HTML. This step powers the interactive ones (dialog, dropdown, select, toast,
form validation, …).

## 5. Mount the toast host (optional)

If you use toasts, render `ToastRegion` once at the end of `<body>` in your
layout. Passing `flash:` makes server flash messages render as toasts on load:

```erb
<%# app/views/layouts/application.html.erb — just before </body> %>
    <%= render PhlexKit::ToastRegion.new(flash: flash) %>
  </body>
```

Then spawn toasts from anywhere on the client:

```js
PhlexKit.toast.success("Saved", { description: "Your changes are live." })
```

## 6. Render components

Components render anywhere Phlex is allowed. The simplest path is a Phlex page
rendered from a normal ERB view, so the Rails layout supplies the asset tags:

```ruby
# app/components/pages/home.rb  (app/components is autoloaded by default)
module Pages
  class Home < Phlex::HTML
    def view_template
      render PhlexKit::Card.new do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardTitle.new { "Create account" }
          render PhlexKit::CardDescription.new { "Enter your email to sign up." }
        end
        render PhlexKit::CardContent.new do
          render PhlexKit::Form.new(action: "/users", method: "post") do
            render PhlexKit::FormField.new do
              render PhlexKit::FormFieldLabel.new(for: "email") { "Email" }
              render PhlexKit::Input.new(
                type: :email, id: "email", name: "email", required: true,
                data: { value_missing: "Email is required.",
                        type_mismatch: "Enter a valid email address." }
              )
              render PhlexKit::FormFieldError.new
            end
            render PhlexKit::Button.new(type: :submit) { "Create account" }
          end
        end
      end
    end
  end
end
```

```erb
<%# app/views/pages/home.html.erb %>
<%= render Pages::Home.new %>
```

```ruby
# config/routes.rb
root "pages#home"
```

```ruby
# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  def home; end
end
```

You can equally render a component straight from an ERB view
(`<%= render PhlexKit::Button.new(variant: :primary) { "Save" } %>`), but note
that composing multi-part components (Card > CardHeader > …) reads best inside a
Phlex `view_template`, where `render` nests cleanly.

---

## How the asset wiring works

The engine (`lib/phlex_kit/engine.rb`) does four things so the zero-build story
holds on Propshaft:

1. Puts `app/components`, `app/assets/stylesheets`, and `app/javascript` on
   Propshaft's load path, so each component's co-located `.css` (and its Stimulus
   controller) is servable and the importmap pins resolve.
2. Zeitwerk-`collapse`s the component folders (`button/button.rb` →
   `PhlexKit::Button`).
3. Prevents Propshaft from serving Ruby source out of `public/assets/`.
4. Appends the gem's `config/importmap.rb` to the host importmap so
   `phlex_kit/controllers` (and every controller module) is pinned for you.

The served CSS is a fingerprinted `@import` chain:

```
/assets/application-<digest>.css
  └─ @import /assets/phlex_kit/phlex_kit-<digest>.css   (the gem manifest)
       ├─ @import /assets/phlex_kit/_tokens-<digest>.css     (the --pk-* theme)
       └─ @import /assets/phlex_kit/<component>/<component>-<digest>.css   (each component)
```

Every hop is `@import url("…")` (Propshaft only fingerprints the `url()` form),
with paths relative to the referencing file — so no path 404s.

## Verifying the install

1. Boot the app (`bin/rails server`) and load a page that renders a component.
2. The page should be **themed** (dark by default) — if it's unstyled, the CSS
   `@import` isn't reaching the browser (check step 3 / your layout's manifest).
3. View source: the `<script type="importmap">` should list
   `phlex_kit/controllers` and per-controller entries.
4. Exercise an interactive component (open a dialog, spawn a toast, trip the
   form validation). The browser console should be error-free.

## Troubleshooting

- **Components render but are unstyled.** Your layout isn't serving the manifest
  that carries the `@import`. In a stock app the default `stylesheet_link_tag
  :app` handles this (step 3); in a custom layout, put the `@import` in the
  manifest you actually link, or link `"phlex_kit/phlex_kit"` directly.
- **Interactive components are inert.** `registerPhlexKitControllers(application)`
  isn't running (step 4), or Stimulus isn't started. Confirm the importmap
  includes `phlex_kit/controllers`.
- **Importmap looks stale after upgrading the gem.** importmap-rails caches the
  drawn map; clear it with `rm -rf tmp/cache` and restart the server.
- **A strict Content-Security-Policy blocks the importmap.** importmap-rails
  emits an inline `<script type="importmap">`; allow it (nonce or hash) as you
  would any importmap app.

## Ejecting a component

To own and edit a component's source (shadcn-style), eject it into your app:

```bash
bin/rails g phlex_kit:component button
```

This copies `button.rb` + `button.css` into `app/components/phlex_kit/button/`
and wires its `@import`; your copy shadows the gem's.
