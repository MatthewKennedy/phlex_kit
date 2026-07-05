# frozen_string_literal: true

require "test_helper"

class ButtonTest < Minitest::Test
  include RenderHelper

  def test_default
    html = render(PhlexKit::Button.new { "Go" })
    assert_includes html, "pk-button"
    assert_includes html, "primary"
    assert_includes html, %(type="button")
  end

  def test_xs_size_and_icon_square
    html = render(PhlexKit::Button.new(size: :xs, icon: true) { "x" })
    assert_includes html, "xs"
    assert_includes html, "icon"
  end

  def test_unknown_size_fails_loud
    assert_raises(KeyError) { render(PhlexKit::Button.new(size: :nope) { "x" }) }
  end

  def test_href_renders_an_anchor_without_type
    html = render(PhlexKit::Button.new(href: "/login") { "Login" })
    assert_includes html, "<a"
    assert_includes html, %(href="/login")
    refute_includes html, %(type=")
  end
end
