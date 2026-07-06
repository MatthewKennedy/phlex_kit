# frozen_string_literal: true

require "test_helper"

# Wave 4 — remaining tractable components ported from ruby_ui (dependency-light).
class Wave4Test < Minitest::Test
  include RenderHelper

  def test_clipboard_has_both_popovers
    html = render(PhlexKit::Clipboard.new { PhlexKit::ClipboardSource.new { "t" } })
    assert_includes html, "phlex-kit--clipboard"
    assert_operator html.scan(/pk-clipboard-popover/).size, :>=, 2
  end

  def test_theme_toggle_wires_toggle_and_theme_controllers
    html = render(PhlexKit::ThemeToggle.new { "x" })
    assert_includes html, "phlex-kit--theme-toggle"
    assert_includes html, "phlex-kit--toggle"
  end

  def test_theme_toggle_caller_wrapper_merges_without_dropping_controller
    html = render(PhlexKit::ThemeToggle.new(wrapper: { class: "extra" }) { "x" })
    assert_includes html, "phlex-kit--theme-toggle"
    assert_includes html, "extra"
  end

  def test_theme_toggle_caller_aria_label_wins_but_wiring_survives
    html = render(PhlexKit::ThemeToggle.new(aria: { label: "Night mode" }) { "x" })
    assert_includes html, %(aria-label="Night mode")
    assert_includes html, "phlex-kit--theme-toggle"
  end

  def test_pagination_item_active_reuses_button
    html = render(PhlexKit::PaginationItem.new(href: "/2", active: true) { "2" })
    assert_includes html, "pk-button outline"
    assert_includes html, %(aria-current="page")
  end

  def test_message_scroller_controller
    assert_includes render(PhlexKit::MessageScroller.new { "x" }), "phlex-kit--message-scroller"
  end

  def test_masked_input_wraps_input
    html = render(PhlexKit::MaskedInput.new(name: "z"))
    assert_includes html, "pk-input"
    assert_includes html, "phlex-kit--masked-input"
  end

  def test_codeblock_renders_pre_code
    html = render(PhlexKit::Codeblock.new("puts 1", syntax: :ruby))
    assert_includes html, "pk-codeblock"
    assert_includes html, "<pre>"
    assert_includes html, "puts 1"
  end
end
