# PhlexKit — Charts (Chart.js on importmap)

`PhlexKit::Chart` is a **thin wrapper**, not a charting library. The kit
deliberately ships no chart dependency (see `chart/chart.rb`). The component
renders a `<canvas>` plus a Stimulus hook (`phlex-kit--chart`) that:

- reads `options:` — a **chart.js-shaped config hash** — from a data value;
- if the host page exposes chart.js as **`window.Chart`**, builds the chart with
  the kit's `--pk-chart-*` series colors and re-renders on theme change;
- otherwise dispatches `phlex-kit--chart:connect` with `{ canvas, options }` so
  you can drive any other charting library you ship.

So "using charts" is really one job: **get a `window.Chart` onto the page.** This
guide does that the zero-build way — Chart.js pinned through **importmap** — and
was validated end-to-end against a fresh `rails new` app (Rails 8.1, importmap +
Propshaft).

> Prerequisite: PhlexKit is already installed and its Stimulus controllers are
> registered (`registerPhlexKitControllers(application)`). See
> [05-PROPSHAFT-INSTALL.md](05-PROPSHAFT-INSTALL.md). Charts need that
> registration — the chart is an interactive component.

---

## 1. Pin Chart.js — use a single-file ESM bundle

Chart.js has a runtime dependency (`@kurkle/color`), and **the obvious command
does not work**:

```bash
bin/importmap pin chart.js      # ⚠️ produces a broken pin — see below
```

importmap-rails downloads Chart.js from jspm as a **split** bundle: the vendored
`chart.js.js` ends up with a dangling relative import (`../_/<hash>.js`) for
`@kurkle/color` that was never downloaded, so the browser fails with:

```
TypeError: Failed to fetch dynamically imported module: …/assets/chart.js-<digest>.js
```

and — because a failed module import aborts the whole entrypoint — your
`application.js` never runs either (no Stimulus, no `window.Chart`). The jsDelivr
`+esm` build has the same class of problem: it imports `@kurkle/color` from an
absolute `/npm/…` path that only resolves on jsDelivr's own origin, so it breaks
once vendored.

**The fix: vendor a single, fully self-contained ESM bundle** (all deps inlined).
esm.sh's bundled build is the reliable source:

```bash
# Download the fully-bundled ESM build (deps inlined) into vendor/javascript.
curl -sL "https://esm.sh/chart.js@4.5.1/es2022/chart.bundle.mjs" \
  -o vendor/javascript/chart.js.js
```

Then pin it by hand (do **not** re-run `bin/importmap pin chart.js`, which would
overwrite this with the broken jspm download):

```ruby
# config/importmap.rb
pin "chart.js", to: "chart.js.js" # @4.5.1 (esm.sh bundle, deps inlined)
```

Sanity check the bundle is self-contained — this should print **nothing**:

```bash
grep -oE 'from *["'"'"'][^"'"'"']*["'"'"']' vendor/javascript/chart.js.js | grep -v '^from *["'"'"']\.'
```

## 2. Expose `window.Chart` before Stimulus starts

The pinned `chart.js` module is tree-shakeable: importing it gives you `Chart`
and `registerables` but **does not** register the controllers/scales/elements and
**does not** set any global. The chart controller looks for `window.Chart` on
connect, so register everything and assign the global **before** `import
"controllers"` runs:

```js
// app/javascript/application.js
import "@hotwired/turbo-rails"

// PhlexKit's Chart wrapper looks for `window.Chart`. Register Chart.js's
// built-ins and expose it globally BEFORE Stimulus starts (import "controllers"
// below), so the chart controller finds it on connect.
import { Chart, registerables } from "chart.js"
Chart.register(...registerables)
window.Chart = Chart

import "controllers"
```

That's the whole wiring. `registerables` pulls in every built-in chart type,
scale, and plugin — trade it for an explicit `Chart.register(BarController,
BarElement, CategoryScale, LinearScale, Legend, …)` list if you want to shrink
the bundle to only the chart types you use.

## 3. Render a chart

`options:` is a chart.js config hash — `type`, `data`, and (nested) `options`.
Leave the **colors out**: the controller fills each dataset from the kit's
`--pk-chart-1..5` tokens and applies the shadcn look (hairline grid, muted ticks,
no axis borders).

```ruby
# app/components/pages/home.rb  (app/components is autoloaded)
module Pages
  class Home < Phlex::HTML
    def view_template
      render PhlexKit::Card.new(style: "max-width: 640px; margin: 3rem auto;") do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardTitle.new { "Monthly revenue" }
          render PhlexKit::CardDescription.new { "Chart.js driven by PhlexKit::Chart" }
        end
        render PhlexKit::CardContent.new do
          render PhlexKit::Chart.new(options: {
            type: "bar",
            data: {
              labels: %w[Jan Feb Mar Apr May Jun],
              datasets: [
                { label: "2025", data: [12, 19, 8, 15, 22, 17] },
                { label: "2026", data: [8, 14, 11, 20, 16, 25] }
              ]
            },
            options: { responsive: true, plugins: { legend: { position: "bottom" } } }
          })
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

Series colors, dark/light theme, and tooltip/legend styling all come from
`--pk-*` tokens. When the user flips the theme (`<html data-theme="…">`), the
controller **destroys and rebuilds** the chart against the new tokens — no page
reload.

## Verifying the install

1. `bin/rails server`, load the page. You should see a **themed** chart (colored
   bars, hairline grid) — not a blank/300×150 canvas.
2. Browser console is error-free.
3. In the console, `typeof window.Chart` is `"function"` and
   `window.Chart.getChart(document.querySelector("canvas.pk-chart"))` returns a
   live chart instance.
4. Toggle the theme — the chart recolors.

If the canvas stays at its default 300×150 and `window.Chart` is `undefined`, a
module import failed (almost always the broken jspm pin from step 1) and took
`application.js` down with it — re-check the vendored bundle is self-contained.

---

## Chart types & options

`options:` passes straight through to chart.js, so everything upstream supports
works: `line`, `bar`, `pie`, `doughnut`, `radar`, `polarArea`, `bubble`,
`scatter`, mixed datasets, stacked scales, custom tooltips, etc. The controller
only injects **defaults** (colors, grid, ticks) via a deep-ish merge and lets
your `options:` win, so you can override any of it. Notable behaviors baked into
the wrapper (`chart/chart_controller.js`):

- **Series color:** dataset _N_ takes `--pk-chart-(N % 5 + 1)`.
- **line / radar** datasets get a translucent fill of the same hue (`+33` alpha)
  and `tension: 0.4`, `pointRadius: 0`.
- **pie / doughnut / polarArea** color each **slice** from the token ramp and use
  `--pk-surface` for slice borders.

## Alternative: the UMD build via a plain script tag

If you'd rather not touch `application.js`, load Chart.js's **UMD** build — it
sets `window.Chart` globally by itself. This is what the kit's own gallery
(`test/dummy`) does:

```bash
curl -sL "https://cdn.jsdelivr.net/npm/chart.js@4.5.1/dist/chart.umd.js" \
  -o vendor/javascript/chartjs.umd.js
```

```erb
<%# in your layout <head>, BEFORE javascript_importmap_tags %>
<%= javascript_include_tag "chartjs.umd" %>
<%= javascript_importmap_tags %>
```

No importmap pin and no `application.js` edit — the global is set before Stimulus
connects. The importmap route (steps 1–2) is preferred when you want Chart.js in
your module graph (tree-shaking, importing it elsewhere); the UMD tag is the
lowest-friction option when you just need charts on the page.

## Troubleshooting

- **Blank canvas, `window.Chart` undefined, no Stimulus.** A pinned module 404'd
  and aborted the entrypoint. It's the jspm split-download pin — replace it with
  the self-contained bundle (step 1).
- **Chart renders but ignores your colors.** That's by design — the controller
  owns colors via `--pk-chart-*`. Override per-dataset in `options.data.datasets`
  if you need specific colors; your values win the merge.
- **Importmap looks stale after re-pinning.** importmap-rails caches the drawn
  map — `rm -rf tmp/cache` and restart the server.
- **`"is not a registered controller/scale"` errors.** You imported `chart.js`
  but didn't `Chart.register(...registerables)` (or didn't register the specific
  pieces your chart type needs). See step 2.
