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
      base = {
        class: "pk-chart",
        data: {
          controller: "phlex-kit--chart",
          phlex_kit__chart_options_value: JSON.generate(@options)
        }
      }
      # Defaults only when the caller didn't supply their own — `mix` would
      # fuse role="img figure" instead of overriding.
      # Canvas content is invisible to AT — announce it as an image with at
      # least a generic name; pass aria: { label: "…" } (or block fallback
      # content) to describe the actual data.
      base[:role] = "img" unless @attrs.key?(:role) || @attrs.key?("role")
      base[:aria] = { label: "Chart" } unless aria_labelled?
      canvas(**mix(base, @attrs), &)
    end
  end
end
