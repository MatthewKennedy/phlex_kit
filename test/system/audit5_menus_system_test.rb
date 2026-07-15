# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 5 — menu-family behavior fixes: menubar closes when focus tabs
# out of the bar, menubar items without href activate without a # navigation,
# navigation menu's hover-close grace is cancelled by re-entering the nav.
class Audit5MenusSystemTest < SystemTestCase
  include InteractionHelpers

  # Tabbing out of the menubar (focus leaves the bar AND the open top-layer
  # panel) must close the open popover="manual" panel.
  def test_menubar_closes_when_focus_tabs_out
    visit "/docs/menubar"
    section = demo("Default")
    bar = section.find(".pk-menubar")
    file_trigger = section.find(".pk-menubar-trigger", text: "File")

    page.execute_script("arguments[0].focus()", file_trigger)
    press(:enter)
    section.assert_selector ".pk-menubar-content:popover-open"

    # Tab until focus has escaped both the bar and the panel (the panel is a
    # top-layer popover but stays a DOM child of the bar, so one check covers
    # both). Normal in-menu focus movement must NOT have closed it already.
    10.times do
      break unless page.evaluate_script(
        "arguments[0].contains(document.activeElement)", bar
      )
      press(:tab)
    end
    refute page.evaluate_script("arguments[0].contains(document.activeElement)", bar),
           "focus should have tabbed out of the menubar"

    section.assert_no_selector ".pk-menubar-content:popover-open"
    assert_equal "false", file_trigger["aria-expanded"]
  end

  # Items without an explicit href render no href="#" — Enter activates the
  # row (closing the menu) without a hash change / scroll-to-top navigation.
  def test_menubar_item_enter_activates_without_hash_navigation
    visit "/docs/menubar"
    section = demo("Default")
    file_trigger = section.find(".pk-menubar-trigger", text: "File")

    page.execute_script("arguments[0].focus()", file_trigger)
    press(:enter)
    section.assert_selector ".pk-menubar-content:popover-open"
    focused = active_element
    assert_includes focused.text, "New Tab"
    refute page.evaluate_script("document.activeElement.hasAttribute('href')"),
           "item without explicit href should render no href"

    press(:enter)
    section.assert_no_selector ".pk-menubar-content:popover-open"
    assert_equal "", page.evaluate_script("location.hash"),
                 "activating an href-less item must not navigate to #"
  end

  # Re-entering the nav over list padding/whitespace (nav mouseenter, not a
  # trigger or panel) must cancel the 150ms grace-close armed by mouseleave.
  def test_navigation_menu_reentering_nav_cancels_pending_grace_close
    visit "/docs/navigation-menu"
    trigger = find(".pk-navigation-menu-trigger", text: "Getting started")
    page.execute_script("arguments[0].focus()", trigger)
    press(:down)
    assert_selector ".pk-navigation-menu-content:popover-open"

    nav = find(".pk-navigation-menu")
    # Leave the nav (arms the 150ms closeSoon), then immediately re-enter over
    # the nav itself — no trigger/panel involved — which must cancel it.
    page.execute_script(<<~JS, nav)
      window.__pkT0 = performance.now()
      arguments[0].dispatchEvent(new MouseEvent("mouseleave"))
      arguments[0].dispatchEvent(new MouseEvent("mouseenter"))
    JS
    wait_until("grace period should have elapsed") do
      page.evaluate_script("performance.now() - window.__pkT0 > 300")
    end
    assert_selector ".pk-navigation-menu-content:popover-open"

    # And the grace timer itself still works: leaving without re-entering
    # closes the panel after the delay.
    page.execute_script(%(arguments[0].dispatchEvent(new MouseEvent("mouseleave"))), nav)
    assert_no_selector ".pk-navigation-menu-content:popover-open"
  end
end
