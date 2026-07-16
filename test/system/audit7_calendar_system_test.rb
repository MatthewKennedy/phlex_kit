# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 7: calendar month-crossing keyboard focus race. Stimulus
# value-changed callbacks fire via MutationObserver (async), so setting
# `viewDateValue` does NOT re-render the grid synchronously — querying the
# still-old grid right after stranded focus on <body> (PageUp/PageDown) or
# needed two presses (ArrowDown off the last row). Fix drives the re-render
# and focuses the target day itself. Poll for the async re-render; never sleep.
class Audit7CalendarSystemTest < SystemTestCase
  include InteractionHelpers

  BASIC = "section.docs-demo:has(h2#basic) [data-controller~='phlex-kit--calendar']"

  # Focus a day in the Basic demo's grid (view is June 2026, selected 06-12).
  def focus_day(iso)
    page.execute_script(
      "document.querySelector(#{BASIC.to_json}).querySelector(`[data-day='#{iso}']`).focus()"
    )
  end

  def active_day
    page.evaluate_script("document.activeElement && document.activeElement.dataset ? document.activeElement.dataset.day : null")
  end

  # PageDown moves the view forward one month and must keep keyboard focus on
  # the same day-of-month in the NEW month — not drop it on <body>.
  def test_page_down_crosses_month_and_keeps_focus
    visit "/docs/calendar"
    demo("Basic").find("[data-day='2026-06-12']") # wait for the grid
    focus_day("2026-06-12")
    press(:page_down)
    wait_until("PageDown should focus 2026-07-12 in the re-rendered July grid") do
      active_day == "2026-07-12"
    end
  end

  # Shift+PageDown jumps a full year (APG date-grid), keeping the same
  # day-of-month and focus.
  def test_shift_page_down_jumps_a_year_and_keeps_focus
    visit "/docs/calendar"
    demo("Basic").find("[data-day='2026-06-12']")
    focus_day("2026-06-12")
    press([ :shift, :page_down ])
    wait_until("Shift+PageDown should focus 2027-06-12") do
      active_day == "2027-06-12"
    end
  end

  # ArrowDown (+7) from a current-month day in the LAST rendered week row lands
  # outside the grid (June 29 → July 6, past June's trailing July-5 cell): the
  # month must cross and focus the target in ONE press, not snap back requiring
  # a second.
  def test_arrow_down_from_last_row_crosses_month_in_one_press
    visit "/docs/calendar"
    demo("Basic").find("[data-day='2026-06-29']") # last-row current-month day
    focus_day("2026-06-29")
    press(:down)
    wait_until("ArrowDown off the last row should focus 2026-07-06 in one press") do
      active_day == "2026-07-06"
    end
  end

  # A min-date boundary HOLDS keyboard focus in place (PageUp can't leave the
  # bounded range) — the fix must not regress the hold semantics into a focus
  # loss. Inject a min of 2026-06-01 so PageUp from June targets out-of-range May.
  def test_page_up_at_min_boundary_holds_focus
    visit "/docs/calendar"
    demo("Basic").find("[data-day='2026-06-12']")
    page.execute_script(
      "document.querySelector(#{BASIC.to_json})" \
      ".setAttribute('data-phlex-kit--calendar-min-date-value', '2026-06-01')"
    )
    focus_day("2026-06-12")
    press(:page_up)
    # PageUp to out-of-range May is a hard boundary: focus stays put, never
    # drops to <body>. Assert synchronously — nothing async should have moved it.
    assert_equal "2026-06-12", active_day,
      "PageUp at the min boundary must hold focus on the current day"
  end
end
