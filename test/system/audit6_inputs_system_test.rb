# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 6: masked_input alphanumeric-literal masks and calendar
# booked-date keyboard travel / date-value normalization.
class Audit6InputsSystemTest < SystemTestCase
  include InteractionHelpers

  # Masks with alphanumeric LITERALS (the country-code "1" in a phone mask)
  # corrupted caret placement: the caret loop counted literal digits as user
  # input, so every keystroke landed before the previous one and digits came
  # out reordered.
  def test_masked_input_supports_alphanumeric_literal_masks
    visit "/docs/masked-input"
    page.execute_script(<<~JS)
      const el = document.querySelector("[data-controller~='phlex-kit--masked-input']");
      el.id = "pk-test-masked";
      el.setAttribute("data-mask", "+1 (###) ###-####");
      el.value = "";
      const parent = el.parentElement, next = el.nextSibling;
      el.remove();
      parent.insertBefore(el, next);
    JS
    input = find("#pk-test-masked")
    input.click
    press("5", "5", "5", "1", "2", "3", "4", "5", "6", "7")
    assert_equal "+1 (555) 123-4567", input.value
  end

  # APG date grid: an isolated booked date is SKIPPED in the travel
  # direction; only a min/max boundary holds focus in place. Feb 12–26 are
  # booked in the demo, so ArrowRight from the 11th lands on the 27th.
  def test_calendar_arrow_keys_skip_over_booked_dates
    visit "/docs/calendar"
    section = demo("Booked dates")
    day11 = section.find("[data-day='2026-02-11']")
    page.execute_script("arguments[0].focus()", day11)
    press(:right)
    focused_day = page.evaluate_script("document.activeElement.dataset.day")
    assert_equal "2026-02-27", focused_day,
      "ArrowRight from Feb 11 should skip the booked 12th–26th and land on the 27th"
  end

  # disabled_dates entries that aren't bare yyyy-MM-dd strings (Time#to_s,
  # datetime ISO strings) silently failed to disable — every other date
  # input goes through parseDate; membership checks must too.
  def test_calendar_disabled_dates_accept_datetime_strings
    visit "/docs/calendar"
    section = demo("Booked dates")
    section.find("[data-day='2026-02-05']") # wait for the grid
    page.execute_script(<<~JS)
      const cal = document.querySelector("section.docs-demo:has(h2#booked-dates) [data-controller~='phlex-kit--calendar']");
      cal.setAttribute("data-phlex-kit--calendar-disabled-dates-value",
        JSON.stringify(["2026-02-05 10:00:00 +0100", "2026-02-06T00:00:00Z"]));
    JS
    # Force a grid re-render (next month, then back).
    section.find("button.pk-calendar-next").click
    section.find("button.pk-calendar-prev").click
    day = section.find("[data-day='2026-02-05']", visible: :all)
    assert day.disabled?, "datetime-string disabled_dates entry did not disable the day"
  end

  # macOS reports the composed character for Option-chords (Option+T → "†"),
  # so matching e.key alone means the alt+t focus hotkey never fires on Mac —
  # the toaster must match e.code.
  def test_toaster_hotkey_matches_e_code_for_mac_option_chords
    visit "/docs/toast"
    within(demo("Default")) { click_button "Default" }
    assert_selector ".pk-toast[data-state='open']"

    page.execute_script(<<~JS)
      document.dispatchEvent(new KeyboardEvent("keydown",
        { key: "†", code: "KeyT", altKey: true, bubbles: true, cancelable: true }));
    JS
    focused = page.evaluate_script(%(document.activeElement.classList.contains("pk-toast")))
    assert focused, "alt+t (macOS: key '†', code KeyT) did not focus the newest toast"
  end

  # Pause/resume events were document-global: ANY document-level pause froze
  # every region's toasts. They must be scoped to the dispatching region, so
  # a foreign pause event leaves this region's auto-dismiss timer running.
  def test_toast_pause_events_are_region_scoped
    visit "/docs/toast"
    within(demo("Default")) { click_button "Default" }
    assert_selector ".pk-toast[data-state='open']"
    page.execute_script(<<~JS)
      document.dispatchEvent(new CustomEvent("phlex-kit:toast:pause"));
    JS
    # Region-scoped listeners ignore the stray document-level event, so the
    # 4s auto-dismiss still runs; document-scoped ones freeze forever.
    assert_no_selector ".pk-toast[data-state='open']", wait: 8
  end
end
