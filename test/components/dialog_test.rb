# frozen_string_literal: true

require "test_helper"

class DialogTest < Minitest::Test
  include RenderHelper

  def test_content_renders_close_button_by_default
    html = render(PhlexKit::DialogContent.new { "body" })
    assert_includes html, "pk-dialog"
    assert_includes html, "pk-overlay-close"
  end

  def test_show_close_button_false_drops_the_x
    html = render(PhlexKit::DialogContent.new(show_close_button: false) { "body" })
    refute_includes html, "pk-overlay-close"
  end

  def test_size_modifier_and_fail_loud
    assert_includes render(PhlexKit::DialogContent.new(size: :lg) { "x" }), "pk-dialog lg"
    assert_raises(KeyError) { render(PhlexKit::DialogContent.new(size: :nope) { "x" }) }
  end

  def test_dialog_close_wraps_with_dismiss_action
    html = render(PhlexKit::DialogClose.new { "Cancel" })
    assert_includes html, "phlex-kit--dialog#dismiss"
    assert_includes html, "display: contents"
  end
end
