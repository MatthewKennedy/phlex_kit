# frozen_string_literal: true

require "test_helper"

class ButtonGroupTest < Minitest::Test
  include RenderHelper

  def test_default_horizontal
    html = render(PhlexKit::ButtonGroup.new { "x" })
    assert_includes html, "pk-button-group"
    assert_includes html, %(role="group")
    refute_includes html, "vertical"
  end

  def test_vertical_orientation
    assert_includes render(PhlexKit::ButtonGroup.new(orientation: :vertical) { "x" }), "vertical"
  end

  def test_unknown_orientation_fails_loud
    assert_raises(KeyError) { render(PhlexKit::ButtonGroup.new(orientation: :diagonal) { "x" }) }
  end

  def test_text_part
    html = render(PhlexKit::ButtonGroupText.new { "https://" })
    assert_includes html, "pk-button-group-text"
    assert_includes html, "https://"
  end

  def test_separator_part
    html = render(PhlexKit::ButtonGroupSeparator.new)
    assert_includes html, "pk-button-group-separator"
    assert_includes html, "aria-hidden"
  end
end
