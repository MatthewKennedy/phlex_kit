# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Task 7: date_picker closes its popover once a calendar selection is
# complete. Single mode closes on any pick; range mode only closes once the
# second end (rangeEnd) is set — the first pick must leave the panel open so
# the user can choose the end date; multiple mode (not reachable through
# DatePicker's public API today — Calendar's toggleMultipleDay path exists,
# but nothing in this suite exercises it) never auto-closes.
class DatePickerSystemTest < SystemTestCase
  include InteractionHelpers

  def test_single_mode_closes_popover_input_reflects_pick_and_focus_returns_to_trigger
    visit "/docs/date-picker"
    section = demo("Basic")
    trigger = section.find(".pk-date-picker-field input")

    trigger.click
    section.assert_selector ".pk-popover-content:popover-open"

    day = section.first(".pk-popover-content .pk-calendar-day:not(.other):not([disabled])")
    picked_iso = day["data-day"]
    day.click

    section.assert_no_selector ".pk-popover-content:popover-open"
    # Basic demo's date_format is the default "yyyy-MM-dd" — matches the
    # picked day's ISO data-day exactly.
    assert_equal picked_iso, trigger.value
    assert active_element.matches_css?(".pk-date-picker-field input"), "focus should return to the trigger input"
  end

  def test_range_mode_does_not_close_on_first_end_but_closes_on_second
    visit "/docs/date-picker"
    section = demo("Range Picker")
    trigger = section.find(".pk-date-picker-field input")

    trigger.click
    section.assert_selector ".pk-popover-content:popover-open"

    # The demo seeds a complete range (2026-06-09 - 2026-06-17), so the very
    # next click begins a FRESH range (only a start, per
    # calendar_controller.js#selectRangeDay) — a genuinely incomplete
    # selection that must not close the panel.
    section.find("[data-day='2026-06-05']").click
    # First pick after the demo's preset range begins a fresh range (start
    # only) — must not close.
    section.assert_selector ".pk-popover-content:popover-open"

    # Picking a later day completes the range (rangeEnd set) and must close.
    section.find("[data-day='2026-06-20']").click
    section.assert_no_selector ".pk-popover-content:popover-open"
    assert active_element.matches_css?(".pk-date-picker-field input"), "focus should return to the trigger input"
  end
end
