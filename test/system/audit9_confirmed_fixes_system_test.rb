# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 9: browser gates for the confirmed discovery-audit fixes with
# real interaction surfaces — APG Tab-out closes on select/combobox and the
# input_otp RTL arrow flip.
class Audit9ConfirmedFixesSystemTest < SystemTestCase
  include InteractionHelpers

  # APG select-only combobox: "Tab: closes the listbox".
  def test_select_closes_when_focus_tabs_out
    visit "/docs/select"
    section = demo("Default")
    section.find(".pk-select-trigger").click
    assert_selector ".pk-select-content:popover-open"

    press(:tab)
    press(:tab) # ensure focus fully leaves trigger + listbox
    assert_no_selector ".pk-select-content:popover-open"
    assert_equal "false", section.find(".pk-select-trigger")["aria-expanded"]
  end

  # APG combobox: "Tab: closes the popup".
  def test_combobox_closes_when_focus_tabs_out
    visit "/docs/combobox"
    section = demo("Basic")
    section.find(".pk-combobox-input-trigger-field").click
    assert_selector ".pk-combobox-popover:popover-open"

    press(:tab)
    press(:tab)
    assert_no_selector ".pk-combobox-popover:popover-open"
  end

  # input_otp: the slot row mirrors in RTL, so the physical arrows flip.
  def test_otp_arrows_follow_visual_direction_in_rtl
    visit "/docs/input-otp"
    page.execute_script(%(document.documentElement.dir = "rtl"))
    section = demo("Default")
    slots = section.all(".pk-input-otp-slot")
    page.execute_script("arguments[0].focus()", slots[1])

    press(:left) # RTL: toward the NEXT slot (visually left)
    wait_until("RTL ArrowLeft should move to the next slot") do
      page.evaluate_script("document.activeElement === arguments[0]", slots[2])
    end

    press(:right) # RTL: back toward the previous slot
    wait_until("RTL ArrowRight should move back to the previous slot") do
      page.evaluate_script("document.activeElement === arguments[0]", slots[1])
    end
  end
end
