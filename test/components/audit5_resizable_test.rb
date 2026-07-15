# frozen_string_literal: true

require "test_helper"

# Round-5 audit: ResizablePanel min_size:/max_size: (shadcn's minSize/maxSize
# percentages) — emitted as data attributes for the resizable controller's
# drag/keyboard clamping.
class Audit5ResizableTest < Minitest::Test
  include RenderHelper

  def test_panel_emits_min_and_max_size_data_attributes
    html = render(PhlexKit::ResizablePanel.new(min_size: 20, max_size: 60) { "x" })
    assert_includes html, %(data-phlex-kit--resizable-min-size="20")
    assert_includes html, %(data-phlex-kit--resizable-max-size="60")
  end

  def test_panel_omits_size_bounds_by_default
    html = render(PhlexKit::ResizablePanel.new { "x" })
    refute_includes html, "data-phlex-kit--resizable-min-size"
    refute_includes html, "data-phlex-kit--resizable-max-size"
  end

  def test_min_and_max_size_are_coerced_numerically
    html = render(PhlexKit::ResizablePanel.new(min_size: "12.5") { "x" })
    assert_includes html, %(data-phlex-kit--resizable-min-size="12.5")

    assert_raises(ArgumentError) { PhlexKit::ResizablePanel.new(min_size: "20%") }
    assert_raises(ArgumentError) { PhlexKit::ResizablePanel.new(max_size: "60px") }
  end

  def test_bounds_compose_with_default_size_and_keep_trailing_semicolon
    html = render(PhlexKit::ResizablePanel.new(default_size: 30, min_size: 20, style: "color: red") { "x" })
    # Trailing ";" on the flex-grow declaration must survive so a caller
    # style: can't fuse into one invalid declaration (documented mix gotcha).
    assert_includes html, %(style="flex-grow: 30; color: red")
    assert_includes html, %(data-phlex-kit--resizable-min-size="20")
    assert_includes html, %(data-phlex-kit--resizable-target="panel")
  end
end
