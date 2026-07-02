module PhlexKit
  # Chart, ported from ruby_ui's RubyUI::Chart — as a thin wrapper only. ruby_ui
  # bundles chart.js; this kit deliberately does NOT (no charting dependency).
  # It renders the <canvas> plus the phlex-kit--chart Stimulus hook, which reads
  # `options:` (a chart.js-shaped config hash) and then:
  #
  #   * if the host exposes chart.js as `window.Chart`, builds the chart with
  #     ruby_ui's token-derived default colors (mapped to --pk-*), re-rendering
  #     on theme change;
  #   * otherwise dispatches "phlex-kit--chart:connect" with { canvas, options }
  #     so the host can drive any charting library it ships.
  #
  #   render PhlexKit::Chart.new(options: { type: "line", data: { labels: [...],
  #     datasets: [{ data: [...] }] } })
  class Chart < BaseComponent
    def initialize(options: {}, **attrs)
      @options = options
      @attrs = attrs
    end

    def view_template(&)
      canvas(**mix({
        class: "pk-chart",
        data: {
          controller: "phlex-kit--chart",
          phlex_kit__chart_options_value: JSON.generate(@options)
        }
      }, @attrs), &)
    end
  end
end
