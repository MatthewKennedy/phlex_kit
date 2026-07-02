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
    this.themeObserver?.disconnect()
    this.chart?.destroy()
    if (!this.chart) {
      this.dispatch("disconnect", { detail: { canvas: this.element } })
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
  // triplets ruby_ui reads — return them as-is.
  getThemeColor(name) {
    return getComputedStyle(document.documentElement).getPropertyValue(`--${name}`).trim()
  }

  defaultThemeColor() {
    return {
      backgroundColor: this.getThemeColor("pk-bg"),
      hoverBackgroundColor: this.getThemeColor("pk-surface-2"),
      borderColor: this.getThemeColor("pk-brand"),
      borderWidth: 1,
    }
  }

  setDefaultColorsForChart() {
    const Chart = this.chartLibrary()
    Chart.defaults.color = this.getThemeColor("pk-muted") // font color
    Chart.defaults.borderColor = this.getThemeColor("pk-border") // border color
    Chart.defaults.backgroundColor = this.getThemeColor("pk-bg") // background color

    // tooltip colors
    Chart.defaults.plugins.tooltip.backgroundColor = this.getThemeColor("pk-surface")
    Chart.defaults.plugins.tooltip.borderColor = this.getThemeColor("pk-border")
    Chart.defaults.plugins.tooltip.titleColor = this.getThemeColor("pk-text")
    Chart.defaults.plugins.tooltip.bodyColor = this.getThemeColor("pk-muted")
    Chart.defaults.plugins.tooltip.borderWidth = 1

    // legend
    Chart.defaults.plugins.legend.labels.boxWidth = 12
    Chart.defaults.plugins.legend.labels.boxHeight = 12
    Chart.defaults.plugins.legend.labels.borderWidth = 0
    Chart.defaults.plugins.legend.labels.useBorderRadius = true
    Chart.defaults.plugins.legend.labels.borderRadius = this.getThemeColor("pk-radius")
  }

  refreshChart() {
    this.chart?.destroy()
    this.initChart()
  }

  // The kit themes via <html data-theme="...">, not a class — watch that.
  initThemeObserver() {
    this.themeObserver = new MutationObserver(() => {
      this.refreshChart()
    })
    this.themeObserver.observe(document.documentElement, { attributeFilter: ["data-theme", "class"] })
  }

  mergeOptionsWithDefaults() {
    return {
      ...this.optionsValue,
      data: {
        ...this.optionsValue.data,
        datasets: (this.optionsValue.data?.datasets || []).map((dataset) => {
          return {
            ...this.defaultThemeColor(),
            ...dataset,
          }
        })
      }
    }
  }
}
