# frozen_string_literal: true

require "test_helper"

# Wave 3 — overlay family ported from ruby_ui (CSS-positioned; native <dialog>).
class Wave3Test < Minitest::Test
  include RenderHelper

  def test_dialog_wraps_with_controller
    assert_includes render(PhlexKit::Dialog.new { }), "phlex-kit--dialog"
  end

  def test_dialog_content_uses_native_dialog_with_close
    html = render(PhlexKit::DialogContent.new { "x" })
    assert_includes html, "<dialog"
    assert_includes html, "pk-overlay-close"
  end

  def test_dialog_size_modifier
    assert_includes render(PhlexKit::DialogContent.new(size: :xl) { "x" }), "pk-dialog xl"
  end

  def test_sheet_content_is_template_with_side
    html = render(PhlexKit::SheetContent.new(side: :left) { "x" })
    assert_includes html, "<template"
    assert_includes html, "pk-sheet-content left"
    assert_includes html, "phlex-kit--sheet-content"
  end

  def test_popover_toggle_wiring
    assert_includes render(PhlexKit::PopoverTrigger.new { "t" }), "pointerdown->phlex-kit--popover#armToggle click->phlex-kit--popover#toggle"
    assert_includes render(PhlexKit::PopoverContent.new { "c" }), 'popover="auto"'
  end

  def test_hover_card_hover_actions
    assert_includes render(PhlexKit::HoverCard.new { "x" }), "mouseenter->phlex-kit--hover-card#show"
  end

  def test_context_menu_item_checked_and_shortcut
    html = render(PhlexKit::ContextMenuItem.new(checked: true, shortcut: "X") { "Item" })
    assert_includes html, "pk-context-menu-check"
    assert_includes html, "pk-context-menu-shortcut"
    assert_includes html, %(role="menuitem")
  end

  def test_context_menu_trigger_contextmenu_action
    assert_includes render(PhlexKit::ContextMenuTrigger.new { "t" }), "contextmenu->phlex-kit--context-menu#open"
  end
end
