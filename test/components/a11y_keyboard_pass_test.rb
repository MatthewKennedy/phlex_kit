# frozen_string_literal: true

require "test_helper"

# Keyboard/ARIA pass across the menu family + alert dialog (audit round 3).
# Markup contracts: every interactive menu row must be reachable by the
# roving keyboard navigation (menuItem target + tabindex), panels must
# declare the menu role their items assume, and the alert dialog clone must
# carry the modal keyboard contract.
class A11yKeyboardPassTest < Minitest::Test
  include RenderHelper

  # -- dropdown_menu ---------------------------------------------------------

  def test_dropdown_content_declares_the_menu_role
    html = render(PhlexKit::DropdownMenuContent.new { "items" })
    assert_includes html, %(role="menu")
  end

  def test_dropdown_checkbox_item_joins_keyboard_navigation
    html = render(PhlexKit::DropdownMenuCheckboxItem.new { "Status Bar" })
    assert_includes html, %(data-phlex-kit--dropdown-menu-target="menuItem")
    assert_includes html, %(tabindex="-1")
    assert_includes html, %(aria-checked="false")
  end

  def test_dropdown_radio_item_joins_keyboard_navigation
    html = render(PhlexKit::DropdownMenuRadioItem.new(name: "pos", value: "top", checked: true) { "Top" })
    assert_includes html, %(data-phlex-kit--dropdown-menu-target="menuItem")
    assert_includes html, %(tabindex="-1")
    assert_includes html, %(aria-checked="true")
  end

  def test_dropdown_sub_trigger_joins_keyboard_navigation
    html = render(PhlexKit::DropdownMenuSubTrigger.new { "More" })
    assert_includes html, %(data-phlex-kit--dropdown-menu-target="menuItem")
    assert_includes html, %(tabindex="-1")
    refute_includes html, %(tabindex="0")
  end

  # -- context_menu ----------------------------------------------------------

  def test_context_checkbox_item_joins_keyboard_navigation
    html = render(PhlexKit::ContextMenuCheckboxItem.new { "Show Bookmarks" })
    assert_includes html, %(data-phlex-kit--context-menu-target="menuItem")
    assert_includes html, %(tabindex="-1")
    assert_includes html, %(aria-checked="false")
  end

  def test_context_radio_item_joins_keyboard_navigation
    html = render(PhlexKit::ContextMenuRadioItem.new(name: "who", value: "pedro", checked: true) { "Pedro" })
    assert_includes html, %(data-phlex-kit--context-menu-target="menuItem")
    assert_includes html, %(tabindex="-1")
    assert_includes html, %(aria-checked="true")
  end

  def test_context_sub_trigger_joins_keyboard_navigation
    html = render(PhlexKit::ContextMenuSubTrigger.new { "More Tools" })
    assert_includes html, %(data-phlex-kit--context-menu-target="menuItem")
    assert_includes html, %(tabindex="-1")
    refute_includes html, %(tabindex="0")
  end

  # -- menubar ---------------------------------------------------------------

  def test_menubar_sub_trigger_is_not_a_tab_stop
    html = render(PhlexKit::MenubarSubTrigger.new { "Share" })
    assert_includes html, %(tabindex="-1")
    refute_includes html, %(tabindex="0")
  end

  # -- alert_dialog ----------------------------------------------------------

  def test_alert_dialog_clone_carries_the_modal_keyboard_contract
    html = render(PhlexKit::AlertDialogContent.new { "body" })
    assert_includes html, "keydown->phlex-kit--alert-dialog#keydown"
    assert_includes html, %(tabindex="-1") # panel focus fallback
    assert_includes html, %(role="alertdialog")
  end

  # -- clipboard -------------------------------------------------------------

  def test_clipboard_popover_is_a_live_region
    html = render(PhlexKit::ClipboardPopover.new(type: :success) { "Copied!" })
    assert_includes html, %(role="status")
  end

  # -- resizable -------------------------------------------------------------

  def test_resizable_handle_wires_keyboard_resizing
    html = render(PhlexKit::ResizableHandle.new)
    assert_includes html, "keydown->phlex-kit--resizable#keydown"
    assert_includes html, %(role="separator")
  end
end
