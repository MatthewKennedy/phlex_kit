# frozen_string_literal: true

require "test_helper"

# Chart — thin wrapper ported from ruby_ui (no bundled charting library; the
# host supplies window.Chart or listens for phlex-kit--chart:connect).
class ChartTest < Minitest::Test
  include RenderHelper

  def test_renders_canvas_with_controller_and_options
    html = render(PhlexKit::Chart.new(options: { type: "line", data: { labels: [ "a" ] } }))
    assert_includes html, "<canvas"
    assert_includes html, "pk-chart"
    assert_includes html, %(data-controller="phlex-kit--chart")
    assert_includes html, "&quot;type&quot;:&quot;line&quot;"
  end

  def test_attrs_pass_through
    html = render(PhlexKit::Chart.new(id: "revenue", class: "tall"))
    assert_includes html, %(id="revenue")
    assert_includes html, "pk-chart tall"
  end
end
