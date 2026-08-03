# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 10 (deferred item): ArrowUp/Down roving must stay in the CURRENT
# menu level. Because a submenu reveals on :focus-within, focusing a sub-trigger
# made its rows visible, and the roving list (recomputed each keystroke) picked
# them up — so ArrowDown on a sub-trigger DOVE into the submenu instead of
# moving to the next parent item (APG reserves ArrowRight/enterKey for entering).
# The same list is what lets arrows rove WITHIN an open submenu, so the fix is a
# context-aware roving list, mirrored across menubar/dropdown/context.
class Audit10SubmenuNavSystemTest < SystemTestCase
  include InteractionHelpers

  # --- menubar ---------------------------------------------------------------

  def test_menubar_arrowdown_on_sub_trigger_stays_in_parent_menu
    open_menubar_submenu
    press(:down)
    wait_until("ArrowDown on the sub-trigger must move to a PARENT item, not dive in") do
      !active_in?(".pk-menubar-sub-content") && active_text == "New Tab"
    end
  end

  def test_menubar_arrowdown_roves_within_an_entered_submenu
    open_menubar_submenu
    press(:right) # LTR: enter the submenu → first sub item
    wait_until("ArrowRight should enter the menubar submenu") { active_text == "Email link" }
    press(:down)
    wait_until("ArrowDown inside the submenu should rove its rows") do
      active_in?(".pk-menubar-sub-content") && active_text == "Messages"
    end
  end

  # --- dropdown --------------------------------------------------------------

  def test_dropdown_arrowdown_on_sub_trigger_stays_in_parent_menu
    open_dropdown_submenu
    press(:down)
    wait_until("ArrowDown on the sub-trigger must move to a PARENT item, not dive in") do
      !active_in?(".pk-dropdown-menu-sub-content") && active_text == "New Tab"
    end
  end

  def test_dropdown_arrowdown_roves_within_an_entered_submenu
    open_dropdown_submenu
    press(:right)
    wait_until("ArrowRight should enter the dropdown submenu") { active_text == "Save Page As…" }
    press(:down)
    wait_until("ArrowDown inside the submenu should rove its rows") do
      active_in?(".pk-dropdown-menu-sub-content") && active_text == "Create Shortcut…"
    end
  end

  # --- context ---------------------------------------------------------------

  def test_context_arrowdown_on_sub_trigger_stays_in_parent_menu
    open_context_submenu
    press(:down)
    wait_until("ArrowDown on the sub-trigger must move to a PARENT item, not dive in") do
      !active_in?(".pk-context-menu-sub-content") && active_text == "Back"
    end
  end

  def test_context_arrowdown_roves_within_an_entered_submenu
    open_context_submenu
    press(:right)
    wait_until("ArrowRight should enter the context submenu") { active_text == "Save Page As…" }
    press(:down)
    wait_until("ArrowDown inside the submenu should rove its rows") do
      active_in?(".pk-context-menu-sub-content") && active_text == "Create Shortcut…"
    end
  end

  private

  def active_text
    page.evaluate_script("document.activeElement && document.activeElement.textContent.trim()")
  end

  def active_in?(selector)
    page.evaluate_script("!!(document.activeElement && document.activeElement.closest(#{selector.to_json}))")
  end

  def focus_sub_trigger(selector)
    trigger = find(selector, text: "More Tools", visible: :all)
    page.execute_script("arguments[0].focus()", trigger)
    wait_until("sub-trigger should hold focus") do
      page.evaluate_script("document.activeElement && document.activeElement.matches(#{selector.to_json})")
    end
  end

  def open_menubar_submenu
    visit "/docs/menubar"
    section = demo("Submenu")
    section.find(".pk-menubar-trigger", text: "File").click
    section.assert_selector ".pk-menubar-content:popover-open"
    share = section.find(".pk-menubar-sub-trigger", text: "Share", visible: :all)
    page.execute_script("arguments[0].focus()", share)
    wait_until("sub-trigger should hold focus") do
      page.evaluate_script("document.activeElement && document.activeElement.matches('.pk-menubar-sub-trigger')")
    end
  end

  def open_dropdown_submenu
    visit "/docs/dropdown-menu"
    section = demo("Submenu")
    section.click_button "Open"
    section.assert_selector ".pk-dropdown-menu-content:popover-open"
    focus_sub_trigger(".pk-dropdown-menu-sub-trigger")
  end

  def open_context_submenu
    visit "/docs/context-menu"
    section = demo("Submenu")
    section.find(".pk-context-menu-trigger").right_click
    section.assert_selector ".pk-context-menu-content:popover-open"
    focus_sub_trigger(".pk-context-menu-sub-trigger")
  end
end
