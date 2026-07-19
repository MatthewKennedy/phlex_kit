import { Controller } from "@hotwired/stimulus"

// Ported from ruby_ui's chart controller with the bundled chart.js dependency
// removed: if the host exposes chart.js as window.Chart the behaviour matches
// upstream (token-derived default colors — mapped to the --pk-* theme — plus a
// re-render on theme change); otherwise a "phlex-kit--chart:connect" event is
// dispatched with { canvas, options } so the host can drive any charting
// library it ships. Only @hotwired/stimulus is required.
// Connects to data-controller="phlex-kit--chart"
export default class extends Controller {
  static values = {
    options: {
      type: Object,
      default: {},
    }
  }

  connect() {
    if (this.chartLibrary()) {
      this.initThemeObserver()
      this.initChart()
    } else {
      // No window.Chart — hand the config to the host's own charting code.
      this.dispatch("connect", { detail: { canvas: this.element, options: this.optionsValue } })
    }
  }

  disconnect() {
    this.disconnectThemeObservers()
    this.chart?.destroy()
    if (!this.chart) {
      // Dispatch on document, not this.element: disconnect() runs AFTER the
      // canvas has left the DOM, so an event fired on it neither bubbles nor
      // reaches document/window — delegated host listeners would never see it.
      // The canvas rides the detail so the host can still match its instance.
      this.dispatch("disconnect", { target: document, detail: { canvas: this.element } })
    }
  }

  chartLibrary() {
    return window.Chart
  }

  initChart() {
    this.setDefaultColorsForChart()
    const ctx = this.element.getContext("2d")
    this.chart = new (this.chartLibrary())(ctx, this.mergeOptionsWithDefaults())
  }

  // Kit tokens are plain color values (hex / color-mix results), not the hsl
  // triplets ruby_ui reads — return them as-is. Resolved from this.element,
  // not document.documentElement: a .pk-dark island (_tokens.css:123-129)
  // sets the --pk-* custom properties at the SUBTREE root, and per-element
  // getComputedStyle correctly picks up the nearest ancestor's values —
  // reading from the document root would ignore the island and always
  // return the page-level theme.
  getThemeColor(name) {
    return getComputedStyle(this.element).getPropertyValue(`--${name}`).trim()
  }

  // shadcn-style series colors: dataset N takes --pk-chart-(N%5 + 1). Line/area
  // datasets get a translucent fill of the same hue; circular charts color each
  // slice instead (below).
  seriesColor(index) {
    return this.getThemeColor(`pk-chart-${(index % 5) + 1}`)
  }

  defaultThemeColor(index) {
    const color = this.seriesColor(index)
    const translucentFill = ["line", "radar"].includes(this.optionsValue.type)
    // color-mix, not hex + "33": the token may be any CSS color — the shipped
    // zinc/neutral themes use oklch(...), and appending an alpha suffix to
    // those produced invalid colors (fills silently broke).
    const translucent = `color-mix(in oklab, ${color} 20%, transparent)`
    return {
      backgroundColor: this.isCircular() ? undefined : (translucentFill ? translucent : color),
      hoverBackgroundColor: color,
      borderColor: color,
      borderWidth: 2,
      pointRadius: 0,
      pointHoverRadius: 4,
      tension: 0.4,
    }
  }

  isCircular() {
    return ["pie", "doughnut", "polarArea"].includes(this.optionsValue.type)
  }

  setDefaultColorsForChart() {
    const Chart = this.chartLibrary()
    // Chart.defaults is a library-wide singleton (chart.js has no per-instance
    // defaults object), so it can only ever reflect ONE theme — the
    // documented caveat. It's resolved from the document root, not
    // this.element: a chart inside a .pk-dark island still gets per-dataset
    // colors from the island (getThemeColor/seriesColor, above), just not
    // these library-global defaults (grid/tooltip/legend chrome).
    //
    // One computed-style resolve for all nine tokens (this runs on every
    // connect; assigning identical values to Chart.defaults is free — charts
    // read defaults at construction — so the style resolves are the only cost
    // worth trimming).
    const styles = getComputedStyle(document.documentElement)
    const token = (name) => styles.getPropertyValue(`--${name}`).trim()

    Chart.defaults.color = token("pk-muted") // font color
    Chart.defaults.borderColor = token("pk-border") // border color
    Chart.defaults.backgroundColor = token("pk-bg") // background color

    // tooltip colors
    Chart.defaults.plugins.tooltip.backgroundColor = token("pk-surface")
    Chart.defaults.plugins.tooltip.borderColor = token("pk-border")
    Chart.defaults.plugins.tooltip.titleColor = token("pk-text")
    Chart.defaults.plugins.tooltip.bodyColor = token("pk-muted")
    Chart.defaults.plugins.tooltip.borderWidth = 1

    // legend
    Chart.defaults.plugins.legend.labels.boxWidth = 12
    Chart.defaults.plugins.legend.labels.boxHeight = 12
    Chart.defaults.plugins.legend.labels.borderWidth = 0
    Chart.defaults.plugins.legend.labels.useBorderRadius = true
    Chart.defaults.plugins.legend.labels.borderRadius = 2

    // shadcn look: hairline grid, no axis borders, muted ticks
    Chart.defaults.scale.grid = { ...Chart.defaults.scale.grid, color: token("pk-border"), drawTicks: false }
    Chart.defaults.scale.border = { ...Chart.defaults.scale.border, display: false }
  }

  refreshChart() {
    this.chart?.destroy()
    this.initChart()
  }

  // The kit themes via <html data-theme="...">, not a class — but a class can
  // re-theme too (.pk-dark, custom theme classes), so watch both. ANY root
  // class mutation fires the observer though, so only rebuild when the
  // resolved token values actually changed — rebuilding every chart on an
  // unrelated class flip is the expensive path.
  initThemeObserver() {
    this._themeKey = this.currentThemeKey()
    const onMutate = () => {
      const key = this.currentThemeKey()
      if (key === this._themeKey) return
      this._themeKey = key
      this.refreshChart()
    }
    this.themeObserver = new MutationObserver(onMutate)
    this.themeObserver.observe(document.documentElement, { attributeFilter: ["data-theme", "class"] })

    // A .pk-dark island (_tokens.css:123-129) re-themes a subtree without
    // touching the document root, so the root-only observer above misses it.
    // Watch the nearest island ancestor too, if this chart lives inside one.
    const island = this.element.closest(".pk-dark")
    if (island && island !== document.documentElement) {
      this.islandObserver = new MutationObserver(onMutate)
      this.islandObserver.observe(island, { attributeFilter: ["data-theme", "class"] })
    }
  }

  disconnectThemeObservers() {
    this.themeObserver?.disconnect()
    this.islandObserver?.disconnect()
  }

  // Cheap fingerprint of the resolved theme: two tokens that differ between
  // every light/dark pair. Resolved from this.element (island-aware, see
  // getThemeColor) so a mutation on an ancestor .pk-dark island is detected
  // even though the document root never changes. One style resolve per
  // mutation vs a full chart rebuild.
  currentThemeKey() {
    const styles = getComputedStyle(this.element)
    return `${styles.getPropertyValue("--pk-bg")}|${styles.getPropertyValue("--pk-text")}`
  }

  mergeOptionsWithDefaults() {
    return {
      ...this.optionsValue,
      data: {
        ...this.optionsValue.data,
        datasets: (this.optionsValue.data?.datasets || []).map((dataset, index) => {
          const defaults = this.defaultThemeColor(index)
          if (this.isCircular()) {
            // one dataset, one color per slice
            defaults.backgroundColor = (dataset.data || []).map((_, i) => this.seriesColor(i))
            defaults.borderColor = this.getThemeColor("pk-surface")
          }
          return {
            ...defaults,
            ...dataset,
          }
        })
      }
    }
  }
}
