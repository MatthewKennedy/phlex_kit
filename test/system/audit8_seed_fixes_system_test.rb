# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 8, seed fixes carried over from round 7:
# - command dialog clone now stamps [data-pk-overlay-clone], so Escape
#   layering resolves across overlay families (command over alert dialog);
# - toast swipe-cancel no longer force-resumes the "hover" pause source
#   while the pointer is still over the toast;
# - combobox Enter-while-closed keeps Enter's default behaviour (deliberate,
#   APG) — it must submit an enclosing form;
# - calendar clears rangeEnd by removing the attribute (retiring the "null"
#   string sentinel date_picker used to guard against);
# - RTL calendar coverage for month-cross and booked-skip specifically.
class Audit8SeedFixesSystemTest < SystemTestCase
  include InteractionHelpers

  # --- command dialog Escape layering ---------------------------------------

  # The palette's Escape binding is window-scoped; with an alert dialog
  # opened first and the palette stacked on top (both are [data-pk-overlay-
  # clone] <body> children), one Escape must close only the palette, the
  # next one the alert dialog.
  def test_escape_closes_only_the_topmost_overlay_command_over_alert_dialog
    visit "/gallery"
    click_button "Delete account"
    assert_selector "[role='alertdialog']"

    # ctrl+K is bound @window, so it opens the palette even while the page
    # behind the alert dialog is inert.
    press([ :ctrl, "k" ])
    assert_selector ".pk-command-dialog"

    press(:escape)
    assert_no_selector ".pk-command-dialog"
    # first Escape must close only the topmost overlay (the palette)
    assert_selector "[role='alertdialog']"

    press(:escape)
    # second Escape closes the alert dialog underneath
    assert_no_selector "[role='alertdialog']"
  end

  # --- toast: swipe-cancel must not resume under the cursor ------------------

  def test_toast_swipe_cancel_keeps_hover_pause_while_pointer_is_over_the_toast
    visit "/docs/toast"
    toast_id = "audit8-swipe-cancel-hover"
    page.execute_script(%(window.PhlexKit.toast("Swipe cancel hover", { duration: 30000, id: #{toast_id.to_json} })))
    assert_selector "#pk-toaster .pk-toast", text: "Swipe cancel hover"

    # Real CDP hover: pointerenter pauses the timer and sets the browser's
    # :hover state (synthetic events can't — matches(":hover") needs this).
    find("##{toast_id}").hover
    wait_until("hovering the toast should pause its timer") do
      page.evaluate_script(toast_controller_js(toast_id, "c._timer === null && c._pauseSources.has('hover')"))
    end

    # Below-threshold swipe driven through the controller's own handlers.
    page.execute_script(<<~JS)
      const el = document.getElementById(#{toast_id.to_json});
      const rect = el.getBoundingClientRect();
      const x0 = rect.left + rect.width / 2, y0 = rect.top + rect.height / 2;
      el.dispatchEvent(new PointerEvent("pointerdown", { bubbles: true, clientX: x0, clientY: y0, pointerId: 3, detail: 1 }));
      el.dispatchEvent(new PointerEvent("pointermove", { bubbles: true, clientX: x0 + 10, clientY: y0, pointerId: 3, detail: 1 }));
      el.dispatchEvent(new PointerEvent("pointerup", { bubbles: true, clientX: x0 + 10, clientY: y0, pointerId: 3, detail: 1 }));
    JS

    # Assert synchronously: the cancelled swipe ended with the pointer still
    # over the toast, so the hover hold must survive (no restarted timer).
    still_paused = page.evaluate_script(toast_controller_js(toast_id, "c._timer === null && c._pauseSources.has('hover')"))
    assert still_paused, "swipe-cancel under the cursor must keep the hover pause"

    # Moving the pointer off the toast resumes it through the normal path.
    page.driver.browser.mouse.move(x: 5, y: 5)
    wait_until("pointer leaving the toast should restart the timer") do
      page.evaluate_script(toast_controller_js(toast_id, "c._timer !== null"))
    end
  end

  # --- combobox: Enter while closed submits an enclosing form ----------------

  # Deliberate (APG): keyEnterPressed bails before preventDefault when the
  # popover is closed, so Enter keeps its ordinary default behaviour — in a
  # form, that's an implicit submit.
  def test_combobox_enter_while_closed_submits_an_enclosing_form
    visit "/docs/combobox"
    section = demo("Basic")
    input = section.find(".pk-combobox-input-trigger-field")

    # Wrap the demo's combobox in a form after load; the submit listener
    # cancels navigation and records the attempt.
    page.execute_script(<<~JS, input)
      const root = arguments[0].closest(".pk-combobox");
      const form = document.createElement("form");
      root.parentElement.insertBefore(form, root);
      form.appendChild(root);
      window.__pkFormSubmitted = false;
      form.addEventListener("submit", (e) => { e.preventDefault(); window.__pkFormSubmitted = true; });
    JS

    # Re-find after the reparent (the move reconnects the controller).
    section.find(".pk-combobox-input-trigger-field").click
    assert_selector ".pk-combobox-popover:popover-open"
    press(:escape)
    assert_no_selector ".pk-combobox-popover:popover-open"

    press(:enter)
    wait_until("Enter on a closed combobox must submit the enclosing form") do
      page.evaluate_script("window.__pkFormSubmitted === true")
    end
  end

  # --- calendar: clearing rangeEnd removes the attribute ---------------------

  # Starting a fresh range used to write rangeEndValue = null, which
  # setAttribute stringified to the literal "null" — the attribute must now
  # be REMOVED (undefined assignment), so consumers read a real null.
  def test_starting_a_fresh_range_removes_the_range_end_attribute
    visit "/docs/calendar"
    section = demo("Range Calendar")
    # The demo seeds a COMPLETE range (2026-01-12 – 2026-02-11), so the next
    # pick begins a fresh range and clears rangeEnd (selectRangeDay).
    section.first(".pk-calendar-day:not(.other):not([disabled])").click

    attr_value = page.evaluate_script(<<~JS)
      (() => {
        const el = document.querySelector("section.docs-demo:has(h2#range-calendar) [data-controller~='phlex-kit--calendar']");
        return el.getAttribute("data-phlex-kit--calendar-range-end-value");
      })()
    JS
    assert_nil attr_value, "clearing rangeEnd must remove the attribute, not write the string 'null'"
  end

  # --- RTL calendar: month-cross and booked-skip -----------------------------

  # In RTL ArrowLeft advances a day; from the last day of June it must cross
  # into July and land focus in the re-rendered grid, not on <body>.
  def test_rtl_arrow_left_crosses_the_month_boundary
    visit "/docs/calendar"
    page.execute_script(%(document.documentElement.dir = "rtl"))
    demo("Basic").find("[data-day='2026-06-30']")
    focus_day("basic", "2026-06-30")

    press(:left)
    wait_until("RTL ArrowLeft from June 30 should focus 2026-07-01 in the July grid") do
      active_day == "2026-07-01"
    end
  end

  # Booked dates are skipped in the travel direction. The Booked demo strikes
  # 2026-02-12..26: RTL ArrowLeft (= +1 day) from Feb 11 must skip the whole
  # booked block and land on Feb 27.
  def test_rtl_arrow_left_skips_booked_dates_in_the_travel_direction
    visit "/docs/calendar"
    page.execute_script(%(document.documentElement.dir = "rtl"))
    demo("Booked dates").find("[data-day='2026-02-11']")
    focus_day("booked-dates", "2026-02-11")

    press(:left)
    wait_until("RTL ArrowLeft from Feb 11 should skip the booked block to 2026-02-27") do
      active_day == "2026-02-27"
    end

    press(:right)
    wait_until("RTL ArrowRight should skip back across the booked block to 2026-02-11") do
      active_day == "2026-02-11"
    end
  end

  private

  def toast_controller_js(toast_id, expression)
    <<~JS
      (() => {
        const el = document.getElementById(#{toast_id.to_json});
        if (!el) return false;
        const c = window.Stimulus.getControllerForElementAndIdentifier(el, "phlex-kit--toast");
        if (!c) return false;
        return #{expression};
      })()
    JS
  end

  def focus_day(slug, iso)
    page.execute_script(
      "document.querySelector(\"section.docs-demo:has(h2##{slug}) [data-controller~='phlex-kit--calendar']\")" \
      ".querySelector(`[data-day='#{iso}']`).focus()"
    )
  end

  def active_day
    page.evaluate_script("document.activeElement && document.activeElement.dataset ? document.activeElement.dataset.day : null")
  end
end
