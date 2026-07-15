# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# The menu family: menubar roving tabindex + keyboard, navigation menu
# arrow-open, context menu right-click open/close, dropdown menu ARIA shape.
class MenusSystemTest < SystemTestCase
  include InteractionHelpers

  def test_menubar_roving_tabindex_and_keyboard_navigation
    visit "/docs/menubar"
    section = demo("Default")

    # Roving tabindex (applied on connect): exactly one trigger is a tab stop.
    section.assert_selector ".pk-menubar-trigger[tabindex='0']", count: 1
    triggers = section.all(".pk-menubar-trigger")
    assert_equal triggers.size - 1, triggers.count { |t| t["tabindex"] == "-1" }

    file_trigger = section.find(".pk-menubar-trigger", text: "File")
    edit_trigger = section.find(".pk-menubar-trigger", text: "Edit")
    page.execute_script("arguments[0].focus()", file_trigger)

    # ArrowRight moves focus AND the roving tab stop to the next trigger.
    press(:right)
    assert_equal "Edit", active_element.text
    assert_equal "0", edit_trigger["tabindex"]
    assert_equal "-1", file_trigger["tabindex"]

    # Enter (a detail-0 click) opens the menu and focuses its first item.
    press(:enter)
    section.assert_selector ".pk-menubar-content:popover-open"
    assert_equal "true", edit_trigger["aria-expanded"]
    focused = active_element
    assert focused.matches_css?("[role='menuitem']"), "first menu item should take focus on keyboard open"
    assert_includes focused.text, "Undo"

    press(:escape)
    section.assert_no_selector ".pk-menubar-content:popover-open"
    assert_equal "false", edit_trigger["aria-expanded"]
    assert_equal "Edit", active_element.text
  end

  def test_navigation_menu_arrow_down_opens_and_escape_refocuses_trigger
    visit "/docs/navigation-menu"
    trigger = find(".pk-navigation-menu-trigger", text: "Getting started")
    page.execute_script("arguments[0].focus()", trigger)

    press(:down)
    assert_selector ".pk-navigation-menu-content:popover-open"
    focused = active_element
    assert focused.matches_css?(".pk-navigation-menu-link"), "ArrowDown should focus the panel's first link"
    assert_equal "Installation", focused.text

    press(:escape)
    assert_no_selector ".pk-navigation-menu-content:popover-open"
    assert_equal "false", trigger["aria-expanded"]
    assert_includes active_element.text, "Getting started"
  end

  def test_context_menu_opens_on_right_click_and_closes_on_right_click_elsewhere
    visit "/docs/context-menu"
    section = demo("Basic")

    section.find(".pk-context-menu-trigger").right_click
    section.assert_selector ".pk-context-menu-content:popover-open"

    # A contextmenu anywhere else closes the open menu.
    find("h1", text: "Context Menu").right_click
    section.assert_no_selector ".pk-context-menu-content:popover-open"
  end

  def test_dropdown_menu_label_is_a_div_and_escape_closes
    visit "/docs/dropdown-menu"
    section = demo("Basic")
    section.click_button "Open"
    section.assert_selector ".pk-dropdown-menu-content:popover-open"

    # role="menu" only allows menuitem/group/separator children — the label
    # must be a plain div, not a heading (shadcn ships a div too).
    label = section.find("[role='menu'] .pk-dropdown-menu-label", text: "My Account")
    assert_equal "div", label.tag_name
    section.assert_no_selector "[role='menu'] h3", visible: :all

    press(:escape)
    section.assert_no_selector ".pk-dropdown-menu-content:popover-open"
    assert_equal "false", section.find("button", text: "Open")["aria-expanded"]
  end
end
