# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 9, phase 2 — drivable misc JS fixes: OTP full-length paste at a
# non-first slot, focus-first-invalid across sibling FormFields, and RTL
# keyboard resizing.
class Audit9Phase2MiscSystemTest < SystemTestCase
  include InteractionHelpers

  # A full-length code pasted into a MIDDLE slot must distribute from slot 1,
  # not from the focused slot (which truncated it and merged stale digits).
  def test_input_otp_full_length_paste_at_middle_slot_fills_from_start
    visit "/docs/input-otp"
    section = demo("Default")
    slots = section.all(".pk-input-otp-slot")

    # Focus the 3rd slot, then paste the whole 6-digit code there.
    slots[2].click
    page.execute_script(<<~JS, slots[2].native)
      const dt = new DataTransfer();
      dt.setData("text", "123456");
      arguments[0].dispatchEvent(new ClipboardEvent("paste", { bubbles: true, cancelable: true, clipboardData: dt }));
    JS

    slots.each_with_index { |slot, i| assert_equal (i + 1).to_s, slot.value }
    assert_equal "123456", section.find("input[name='code']", visible: :hidden).value
  end

  # With two invalid FormFields, submitting must focus the FIRST invalid control
  # in document order (native behavior), not the last one — the per-controller
  # focus restore inverted this.
  def test_focus_lands_on_first_invalid_field_across_form_fields
    visit "/docs/form"
    section = demo("Profile form")
    within(section) { click_button "Update profile" }

    username = section.find("#form-username")
    wait_until("first invalid control (username) should be focused") do
      active_element.native == username.native
    end
  end

  # Horizontal keyboard arrows follow visual direction in RTL: ArrowLeft grows
  # the DOM-first panel (it sits on the right), the reverse of LTR.
  def test_resizable_arrow_left_grows_first_panel_in_rtl
    visit "/docs/resizable"
    section = demo("Default")
    page.execute_script("document.dir = 'rtl'")

    handle = section.first(".pk-resizable-handle")
    panel = section.first(".pk-resizable-panel")
    page.execute_script("arguments[0].focus()", handle)

    before = grow_of(panel)
    press(:left)
    wait_until("RTL ArrowLeft should GROW the DOM-first panel") do
      grow_of(panel) > before
    end
  ensure
    page.execute_script("document.dir = 'ltr'")
  end

  private

  def grow_of(element)
    page.evaluate_script("parseFloat(getComputedStyle(arguments[0]).flexGrow)", element)
  end
end
