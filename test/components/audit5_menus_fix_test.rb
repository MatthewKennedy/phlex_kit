# frozen_string_literal: true

require "test_helper"

# Audit round 5 — menu-family fixes (menubar, navigation_menu).
class Audit5MenusFixTest < Minitest::Test
  include RenderHelper

  # -- menubar ---------------------------------------------------------------

  # role="radiogroup" may not own role="menuitemradio" children (axe:
  # aria-required-children). Radix/shadcn render a plain role="group" here.
  def test_menubar_radio_group_uses_group_role
    html = render(PhlexKit::MenubarRadioGroup.new { "x" })
    assert_includes html, %(role="group")
    refute_includes html, %(role="radiogroup")
  end

  # Caller-provided attrs (aria-label etc) still pass through the group.
  def test_menubar_radio_group_passes_aria_label_through
    html = render(PhlexKit::MenubarRadioGroup.new(aria: { label: "People" }) { "x" })
    assert_includes html, %(aria-label="People")
    assert_includes html, %(role="group")
  end

  # An item without an explicit href must not default to href="#" — Enter or
  # click would navigate to # (hash change + scroll-to-top). Focusability is
  # unaffected: the controller manages focus via tabindex="-1".
  def test_menubar_item_omits_href_when_not_given
    html = render(PhlexKit::MenubarItem.new { "New Tab" })
    refute_includes html, "href"
    assert_includes html, %(role="menuitem")
    assert_includes html, %(tabindex="-1")
  end

  def test_menubar_item_keeps_explicit_href
    html = render(PhlexKit::MenubarItem.new(href: "/tabs/new") { "New Tab" })
    assert_includes html, %(href="/tabs/new")
  end

  # Tabbing out of the menubar must close the open popover="manual" panel —
  # the bar wires focusout to the controller's onFocusout.
  def test_menubar_wires_focusout_to_close_on_focus_leaving
    html = render(PhlexKit::Menubar.new { "x" })
    assert_includes html, "focusout->phlex-kit--menubar#onFocusout"
  end

  # -- navigation_menu -------------------------------------------------------

  # Re-entering the nav over list padding/whitespace (not a trigger or panel)
  # must cancel the pending hover-close grace timer.
  def test_navigation_menu_cancels_pending_close_on_nav_mouseenter
    html = render(PhlexKit::NavigationMenu.new { "x" })
    assert_includes html, "mouseleave->phlex-kit--menubar#closeSoon"
    assert_includes html, "mouseenter->phlex-kit--menubar#cancelClose"
  end
end
