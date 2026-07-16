# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 7, task 16 — remaining system-test coverage gaps: toast swipe-to-dismiss,
# masked-input mid-string deletion/caret reseating, OTP paste distribution +
# autofill, slider drag/keyboard --pk-slider-progress sync, and a
# radio-group-inside-FormField exercising the Task 10 multi-target recompute
# against native radio-GROUP validity.
class Audit7CoverageGapsSystemTest < SystemTestCase
  include InteractionHelpers

  # --- Toast swipe-to-dismiss -------------------------------------------

  def test_toast_swipe_past_threshold_dismisses_it
    visit "/docs/toast"
    toast_id = "task16-swipe-dismiss"
    page.execute_script(%(window.PhlexKit.toast("Swipe to dismiss", { duration: 30000, id: #{toast_id.to_json} })))
    assert_selector "#pk-toaster .pk-toast", text: "Swipe to dismiss"

    # Drive the controller's own pointer handlers directly (no real OS-level
    # drag over Cuprite) — down, move past SWIPE_THRESHOLD (45px), up.
    page.execute_script(<<~JS)
      const el = document.getElementById(#{toast_id.to_json});
      const rect = el.getBoundingClientRect();
      const x0 = rect.left + rect.width / 2, y0 = rect.top + rect.height / 2;
      el.dispatchEvent(new PointerEvent("pointerdown", { bubbles: true, clientX: x0, clientY: y0, pointerId: 1, detail: 1 }));
      el.dispatchEvent(new PointerEvent("pointermove", { bubbles: true, clientX: x0 + 200, clientY: y0, pointerId: 1, detail: 1 }));
    JS
    assert_selector "#pk-toaster .pk-toast[data-swipe='move']", text: "Swipe to dismiss"
    swipe_x = page.evaluate_script(%(document.getElementById(#{toast_id.to_json}).style.getPropertyValue("--pk-toast-swipe-x")))
    assert_equal "200px", swipe_x

    page.execute_script(<<~JS)
      const el = document.getElementById(#{toast_id.to_json});
      const rect = el.getBoundingClientRect();
      const y0 = rect.top + rect.height / 2;
      el.dispatchEvent(new PointerEvent("pointerup", { bubbles: true, clientX: rect.left + rect.width / 2 + 200, clientY: y0, pointerId: 1, detail: 1 }));
    JS

    closing = page.evaluate_script(%(document.getElementById(#{toast_id.to_json})?.dataset.swipe === "end"))
    assert closing, "a swipe past the threshold must arm data-swipe=end"
    wait_until("swiped-past-threshold toast should be removed") do
      page.evaluate_script(%(document.getElementById(#{toast_id.to_json}))).nil?
    end
  end

  def test_toast_swipe_below_threshold_cancels_and_clears_swipe_vars
    visit "/docs/toast"
    toast_id = "task16-swipe-cancel"
    page.execute_script(%(window.PhlexKit.toast("Swipe cancel", { duration: 30000, id: #{toast_id.to_json} })))
    assert_selector "#pk-toaster .pk-toast", text: "Swipe cancel"

    page.execute_script(<<~JS)
      const el = document.getElementById(#{toast_id.to_json});
      const rect = el.getBoundingClientRect();
      const x0 = rect.left + rect.width / 2, y0 = rect.top + rect.height / 2;
      el.dispatchEvent(new PointerEvent("pointerdown", { bubbles: true, clientX: x0, clientY: y0, pointerId: 2, detail: 1 }));
      el.dispatchEvent(new PointerEvent("pointermove", { bubbles: true, clientX: x0 + 10, clientY: y0, pointerId: 2, detail: 1 }));
    JS
    assert_selector "#pk-toaster .pk-toast[data-swipe='move']", text: "Swipe cancel"

    page.execute_script(<<~JS)
      const el = document.getElementById(#{toast_id.to_json});
      const rect = el.getBoundingClientRect();
      const y0 = rect.top + rect.height / 2;
      // Spin-wait (not a Ruby-level sleep) so dt is large enough that the
      // controller's distance/time velocity check doesn't itself cross the
      // dismiss threshold — dispatching pointerup back-to-back with the
      // pointermove above would otherwise read as a near-instant, high-
      // velocity flick even though the distance is well under the 45px cutoff.
      const start = performance.now();
      while (performance.now() - start < 60) {}
      el.dispatchEvent(new PointerEvent("pointerup", { bubbles: true, clientX: rect.left + rect.width / 2 + 10, clientY: y0, pointerId: 2, detail: 1 }));
    JS

    # Below SWIPE_THRESHOLD (45px) and low velocity: cancels rather than
    # dismissing, and the inline swipe vars used as the drag's live position
    # must be cleared so the toaster's stacking transform takes back over.
    assert_selector "#pk-toaster .pk-toast[data-swipe='cancel']", text: "Swipe cancel"
    swipe_x = page.evaluate_script(<<~JS)
      document.getElementById(#{toast_id.to_json}).style.getPropertyValue("--pk-toast-swipe-x")
    JS
    swipe_y = page.evaluate_script(<<~JS)
      document.getElementById(#{toast_id.to_json}).style.getPropertyValue("--pk-toast-swipe-y")
    JS
    assert_equal "", swipe_x
    assert_equal "", swipe_y
    # A cancelled swipe must not dismiss the toast.
    assert_selector "#pk-toaster .pk-toast", text: "Swipe cancel"
  end

  # --- Masked input mid-string deletion / caret reseating ---------------

  def test_masked_input_mid_string_backspace_reseats_caret_and_reflows_mask
    visit "/docs/masked-input"
    field = find("input[placeholder='Date: ##/##/####']")

    field.click
    "12311999".chars.each { |digit| press(digit) }
    assert_equal "12/31/1999", field.value

    # Move the caret from the end (index 10) to index 4 — right between the
    # two day digits ("31") — then delete the first day digit ("3").
    6.times { press(:left) }
    assert_equal 4, page.evaluate_script("document.activeElement.selectionStart")
    press(:backspace)

    # One raw digit removed re-flows every group after it: "12" / "11" (was
    # "31", now missing its first digit) / "999" (short — only 3 digits left
    # of the original 8).
    assert_equal "12/11/999", field.value
    # The caret must reseat to just after the last user-typed digit before
    # the deletion point ("12"), not fall through to the end of the string —
    # this is the caret-reseating bug the mask's tokenPos math guards against.
    assert_equal 2, page.evaluate_script("document.activeElement.selectionStart")
  end

  # --- Input OTP paste distribution + autofill ---------------------------

  def test_input_otp_paste_distributes_across_slots
    visit "/docs/input-otp"
    section = demo("Default")
    slots = section.all(".pk-input-otp-slot")

    slots.first.click
    page.execute_script(<<~JS, slots.first.native)
      const dt = new DataTransfer();
      dt.setData("text", "123456");
      arguments[0].dispatchEvent(new ClipboardEvent("paste", { bubbles: true, cancelable: true, clipboardData: dt }));
    JS

    slots.each_with_index { |slot, i| assert_equal (i + 1).to_s, slot.value }
    assert_equal "123456", section.find("input[name='code']", visible: :hidden).value
    wait_until("focus should land on the last filled slot after paste") do
      active_element.native == slots.last.native
    end
  end

  def test_input_otp_paste_strips_non_digits_from_numeric_slots
    visit "/docs/input-otp"
    section = demo("Default")
    slots = section.all(".pk-input-otp-slot")

    page.execute_script(<<~JS, slots.first.native)
      const dt = new DataTransfer();
      dt.setData("text", "code: 1-2-3-4-5-6!");
      arguments[0].dispatchEvent(new ClipboardEvent("paste", { bubbles: true, cancelable: true, clipboardData: dt }));
    JS

    slots.each_with_index { |slot, i| assert_equal (i + 1).to_s, slot.value }
  end

  def test_input_otp_autofill_style_multichar_input_distributes_across_slots
    visit "/docs/input-otp"
    section = demo("Default")
    slots = section.all(".pk-input-otp-slot")

    # autocomplete="one-time-code" autofill sets the focused slot's .value to
    # the WHOLE code directly, then fires a single "input" event whose
    # e.data is the full string (not a single character) — simulate that
    # shape rather than a real OS-level autofill (unavailable in Cuprite).
    page.execute_script(<<~JS, slots.first.native)
      const slot = arguments[0];
      slot.value = "654321";
      slot.dispatchEvent(new InputEvent("input", { bubbles: true, data: "654321", inputType: "insertReplacementText" }));
    JS

    slots.each_with_index { |slot, i| assert_equal "654321"[i], slot.value }
    assert_equal "654321", section.find("input[name='code']", visible: :hidden).value
  end

  # --- Slider progress sync -----------------------------------------------

  def test_slider_keyboard_updates_progress_custom_property
    visit "/docs/slider"
    section = demo("Default")
    slider = section.find("input.pk-slider[name='volume']")

    initial = page.evaluate_script(<<~JS, slider.native)
      getComputedStyle(arguments[0]).getPropertyValue("--pk-slider-progress")
    JS
    assert_equal "50%", initial.strip

    # Focus via script rather than a real click — clicking a native range
    # input's track jumps the thumb to the click's x position, which would
    # clobber the known starting value before we ever press a key.
    page.execute_script("arguments[0].focus()", slider.native)
    press(:right)
    press(:right)

    assert_equal "52", slider.value
    updated = page.evaluate_script(<<~JS, slider.native)
      getComputedStyle(arguments[0]).getPropertyValue("--pk-slider-progress")
    JS
    assert_equal "52%", updated.strip
  end

  def test_slider_programmatic_value_change_updates_progress_on_input_event
    visit "/docs/slider"
    section = demo("Default")
    slider = section.find("input.pk-slider[name='volume']")

    # Mirrors a drag: setting .value then dispatching "input" (what the
    # native range thumb does as it's dragged) must re-sync the property,
    # not just keyboard stepping.
    page.execute_script(<<~JS, slider.native)
      const el = arguments[0];
      el.value = 90;
      el.dispatchEvent(new Event("input", { bubbles: true }));
    JS

    updated = page.evaluate_script(<<~JS, slider.native)
      getComputedStyle(arguments[0]).getPropertyValue("--pk-slider-progress")
    JS
    assert_equal "90%", updated.strip
  end

  # --- Radio group inside FormField (Task 10 recompute, native group validity) ---

  def test_radio_group_form_field_shared_error_clears_across_the_whole_group
    visit "/docs/form"
    section = demo("Radio group plan")
    field = section.find(".pk-form-field:has(#form-plan-monthly)")
    monthly = field.find("#form-plan-monthly", visible: :all)
    yearly = field.find("#form-plan-yearly", visible: :all)

    # Submitting with none selected fires `invalid` on the first radio in
    # the group; its required message is shown.
    section.click_button "Subscribe"
    error = field.find(".pk-form-field-error", text: "Pick a subscription plan.")
    assert_equal "true", monthly["aria-invalid"]
    assert_includes monthly["aria-describedby"].to_s.split, error[:id]

    # Checking ANY radio in a native named group makes the WHOLE group
    # valid (browser semantics) — the controller must recompute across all
    # of its input targets, not just the one that received the click, or
    # the still-unchecked radios would keep stale aria-invalid/error state.
    yearly.click
    field.assert_selector ".pk-form-field-error.pk-hidden", visible: :all
    assert_nil monthly["aria-invalid"]
    assert_nil yearly["aria-invalid"]
    refute_includes monthly["aria-describedby"].to_s.split, error[:id]
  end
end
