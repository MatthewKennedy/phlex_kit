# frozen_string_literal: true

require "test_helper"

# Audit round 2 — a11y contracts for the menu-pattern components (menubar,
# context menu, navigation menu).
class A11yMenusTest < Minitest::Test
  include RenderHelper

  def test_menubar_trigger_is_a_menuitem
    html = render(PhlexKit::MenubarTrigger.new { "File" })
    assert_includes html, %(role="menuitem")
    assert_includes html, %(aria-expanded="false")
  end

  def test_menubar_checkbox_item_exposes_aria_checked_and_unfocusable_input
    html = render(PhlexKit::MenubarCheckboxItem.new(checked: true) { "Always Show Bookmarks" })
    assert_includes html, %(aria-checked="true")
    assert_includes html, %(tabindex="-1")
    assert_includes html, "change->phlex-kit--menubar#syncChecked"
    assert_includes render(PhlexKit::MenubarCheckboxItem.new { "x" }), %(aria-checked="false")
  end

  def test_menubar_radio_item_exposes_aria_checked
    html = render(PhlexKit::MenubarRadioItem.new(name: "who", value: "andy", checked: true) { "Andy" })
    assert_includes html, %(aria-checked="true")
    assert_includes html, "change->phlex-kit--menubar#syncChecked"
  end

  def test_menubar_item_disabled_is_marked_and_inert
    html = render(PhlexKit::MenubarItem.new(disabled: true) { "Print" })
    assert_includes html, %(data-disabled="true")
    assert_includes html, %(aria-disabled="true")
    refute_includes html, "phlex-kit--menubar#close"
  end

  def test_menubar_item_default_stays_activatable
    html = render(PhlexKit::MenubarItem.new { "New Tab" })
    assert_includes html, "click->phlex-kit--menubar#close"
    refute_includes html, "data-disabled"
  end

  def test_navigation_menu_content_has_no_menu_role
    refute_includes render(PhlexKit::NavigationMenuContent.new { "links" }), %(role="menu")
  end

  def test_context_menu_item_keeps_menuitem_role_and_declared_target
    html = render(PhlexKit::ContextMenuItem.new { "Copy" })
    assert_includes html, %(role="menuitem")
    assert_includes html, %(data-phlex-kit--context-menu-target="menuItem")
  end

  def test_context_menu_item_disabled_is_marked_and_inert
    html = render(PhlexKit::ContextMenuItem.new(disabled: true) { "Paste" })
    assert_includes html, %(data-disabled="true")
    assert_includes html, %(aria-disabled="true")
    refute_includes html, "phlex-kit--context-menu#close"
  end
end
