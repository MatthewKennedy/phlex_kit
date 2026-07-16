# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 7: the RTL keyboard cluster. Direction-aware ArrowLeft/ArrowRight
# for tabs, toggle_group, calendar and the three menu systems, plus sub-trigger
# chevron mirroring. Chrome evaluates runtime JS direction checks
# (getComputedStyle(...).direction) reliably even after a dynamic dir flip, and
# an ancestor [dir="rtl"] attribute selector (unlike the :dir() pseudo) is
# re-styled dynamically — so flipping document.dir after visit is sufficient.
class Audit7RtlKeyboardSystemTest < SystemTestCase
  include InteractionHelpers

  def force_rtl
    page.execute_script(%(document.documentElement.dir = "rtl"))
  end

  # --- tabs: horizontal arrows follow visual direction -----------------------

  # Line demo has three triggers: overview(0) analytics(1) reports(2). In RTL
  # the "next" tab sits to the physical LEFT, so ArrowLeft advances.
  def test_tabs_arrow_left_advances_in_rtl
    visit "/docs/tabs"
    force_rtl
    section = demo("Line")
    overview = section.find(".pk-tabs-trigger", text: "Overview")
    page.execute_script("arguments[0].focus()", overview)

    press(:left)
    assert_equal "active", section.find(".pk-tabs-trigger", text: "Analytics")["data-state"],
                 "RTL ArrowLeft should advance tabs to the next (Analytics)"

    press(:right)
    assert_equal "active", section.find(".pk-tabs-trigger", text: "Overview")["data-state"],
                 "RTL ArrowRight should step back to the previous (Overview)"
  end

  # --- toggle_group (single): arrows flip AND check follows -------------------

  # Default demo: left(0) center(1, selected) right(2), type single, name=align.
  # Single-type checks on navigate, so a wrong direction mutates form state.
  def test_toggle_group_arrow_left_selects_next_in_rtl
    visit "/docs/toggle-group"
    force_rtl
    section = demo("Default")
    center = section.find(".pk-toggle-group-item", text: "Center")
    page.execute_script("arguments[0].focus()", center)

    press(:left)
    right = section.find(".pk-toggle-group-item", text: "Right")
    assert_equal "on", right["data-state"], "RTL ArrowLeft should move to and check Right"
    assert_equal "true", right["aria-checked"]
    assert_equal "right",
                 section.find("input[name='align']", visible: :all).value,
                 "single toggle_group form value must follow the RTL navigation"
  end

  # --- calendar: day delta flips (grid rows mirror in RTL) --------------------

  def test_calendar_arrow_left_moves_to_next_day_in_rtl
    visit "/docs/calendar"
    force_rtl
    section = demo("Basic")
    section.find("[data-day='2026-06-12']")
    page.execute_script(
      "document.querySelector(#{section_calendar.to_json}).querySelector(\"[data-day='2026-06-12']\").focus()"
    )

    press(:left)
    wait_until("RTL ArrowLeft should move to the NEXT day (2026-06-13)") do
      active_day == "2026-06-13"
    end

    press(:right)
    wait_until("RTL ArrowRight should move back a day (2026-06-12)") do
      active_day == "2026-06-12"
    end
  end

  # --- dropdown submenu: enter/exit keys follow visual direction -------------

  # Panels open inline-end (visually LEFT in RTL), so ArrowLeft enters the
  # submenu and ArrowRight steps back out.
  def test_dropdown_submenu_enter_exit_keys_in_rtl
    visit "/docs/dropdown-menu"
    force_rtl
    section = demo("Submenu")
    section.click_button "Open"
    sub_trigger = section.find(".pk-dropdown-menu-sub-trigger", text: "More Tools")
    page.execute_script("arguments[0].focus()", sub_trigger)

    press(:left) # RTL: enter the submenu
    wait_until("RTL ArrowLeft should enter the dropdown submenu") do
      page.evaluate_script("document.activeElement && document.activeElement.textContent.trim()") == "Save Page As…"
    end

    press(:right) # RTL: step back out to the sub trigger
    wait_until("RTL ArrowRight should exit back to the sub trigger") do
      page.evaluate_script(
        "document.activeElement && document.activeElement.classList.contains('pk-dropdown-menu-sub-trigger')"
      )
    end
  end

  # --- menubar: closed-bar traversal follows visual direction ----------------

  # Default bar: File Edit View Profiles. In RTL ArrowLeft moves to the visually
  # left (next) trigger — Edit — rather than wrapping to the last one.
  def test_menubar_arrow_left_moves_to_next_trigger_in_rtl
    visit "/docs/menubar"
    force_rtl
    section = demo("Default")
    file = section.find(".pk-menubar-trigger", text: "File")
    page.execute_script("arguments[0].focus()", file)

    press(:left)
    assert_equal "Edit",
                 page.evaluate_script("document.activeElement && document.activeElement.textContent.trim()"),
                 "RTL ArrowLeft on the closed menubar should focus the next (Edit) trigger"
  end

  # --- chevron mirroring: RTL arm flips the sub-trigger chevron ---------------

  def test_dropdown_sub_trigger_chevron_mirrors_in_rtl
    visit "/docs/dropdown-menu"
    force_rtl
    section = demo("Submenu")
    section.click_button "Open"
    chevron = section.find(".pk-dropdown-menu-sub-chevron", visible: :all)

    transform = page.evaluate_script("getComputedStyle(arguments[0]).transform", chevron)
    assert_equal "matrix(-1, 0, 0, 1, 0, 0)", transform,
                 "RTL sub-trigger chevron must be horizontally mirrored (scaleX(-1))"
  end

  private

  def section_calendar
    "section.docs-demo:has(h2#basic) [data-controller~='phlex-kit--calendar']"
  end

  def active_day
    page.evaluate_script("document.activeElement && document.activeElement.dataset ? document.activeElement.dataset.day : null")
  end
end
