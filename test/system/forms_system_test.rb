# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Form-side widgets: OTP slot distribution, masked input, collapsible,
# tabs (mouse + keyboard), live form-field validation, theme toggle.
class FormsSystemTest < SystemTestCase
  include InteractionHelpers

  def test_input_otp_distributes_typed_digits_and_syncs_hidden_input
    visit "/docs/input-otp"
    section = demo("Default")
    slots = section.all(".pk-input-otp-slot")
    assert_equal 6, slots.size

    slots.first.click
    # press re-resolves focus per keystroke — the controller auto-advances.
    "123456".chars.each { |digit| press(digit) }

    slots.each_with_index { |slot, i| assert_equal (i + 1).to_s, slot.value }
    assert_equal "123456", section.find("input[name='code']", visible: :hidden).value
  end

  def test_masked_input_formats_date_and_drops_wrong_class_characters
    visit "/docs/masked-input"
    field = find("input[placeholder='Date: ##/##/####']")
    field.send_keys "12a31x1999"
    assert_equal "12/31/1999", field.value
  end

  def test_collapsible_toggles_aria_expanded_and_content_visibility
    visit "/docs/collapsible"
    section = demo("Basic")
    # Wait for connect (it stamps the closed state).
    section.assert_selector ".pk-collapsible[data-state='closed']"

    section.click_button "Product details"
    section.assert_selector ".pk-collapsible-trigger[aria-expanded='true']"
    section.assert_selector ".pk-collapsible-content:not(.pk-hidden)"
    section.assert_text "This panel can be expanded or collapsed"

    section.click_button "Product details"
    section.assert_selector ".pk-collapsible-trigger[aria-expanded='false']"
    section.assert_selector ".pk-collapsible-content.pk-hidden", visible: :all
  end

  def test_tabs_swap_panels_and_answer_to_arrow_home_end
    visit "/docs/tabs"
    # The docs demo frames are themselves Tabs — scope to the example's own set.
    tabs = demo("Default").find(".docs-demo-preview .pk-tabs")

    assert_equal 1, tabs.all(".pk-tabs-content:not(.pk-hidden)").size
    tabs.assert_text "Make changes to your account here."

    tabs.find(".pk-tabs-trigger", text: "Password").click
    tabs.assert_selector ".pk-tabs-trigger[aria-selected='true']", text: "Password"
    tabs.assert_selector ".pk-tabs-trigger[aria-selected='false']", text: "Account"
    tabs.assert_text "Change your password here."
    assert_equal 1, tabs.all(".pk-tabs-content:not(.pk-hidden)").size

    # APG keyboard on the tablist: arrows move focus AND activate; Home/End jump.
    press(:right) # wraps from Password back to Account
    assert_equal "Account", active_element.text
    tabs.assert_selector ".pk-tabs-trigger[aria-selected='true']", text: "Account"

    press(:end)
    assert_equal "Password", active_element.text
    tabs.assert_selector ".pk-tabs-trigger[aria-selected='true']", text: "Password"

    press(:home)
    assert_equal "Account", active_element.text
    tabs.assert_selector ".pk-tabs-trigger[aria-selected='true']", text: "Account"
  end

  def test_form_field_error_appears_on_invalid_and_describedby_round_trips
    visit "/docs/form"
    section = demo("Profile form")
    field = section.find(".pk-form-field:has(#form-username)")
    input = field.find("#form-username")

    # Submitting empty fires `invalid` on the required control.
    section.click_button "Update profile"
    error = field.find(".pk-form-field-error", text: "Username is required.")
    refute_empty error[:id].to_s
    assert_includes input["aria-describedby"].to_s.split, error[:id]
    assert_equal "true", input["aria-invalid"]

    # Making the field valid live-clears the message and the describedby link.
    input.send_keys "phlex"
    field.assert_selector ".pk-form-field-error.pk-hidden", visible: :all
    refute_includes input["aria-describedby"].to_s.split, error[:id]
    assert_nil input["aria-invalid"]
  end

  def test_theme_toggle_flips_persists_and_falls_back_to_system
    visit "/docs/button"
    # Connect resolves to "system" when nothing is stored (the layout's
    # server-rendered "dark" is only the pre-JS default).
    assert_selector "html[data-theme='system']"

    find("button[aria-label='Toggle theme']", match: :first).click
    assert_selector "html:not([data-theme='system'])"
    theme = page.evaluate_script("document.documentElement.dataset.theme")
    assert_includes %w[dark light], theme

    visit "/docs/button"
    assert_selector "html[data-theme='#{theme}']"

    page.execute_script("localStorage.removeItem('theme')")
    visit "/docs/button"
    assert_selector "html[data-theme='system']"
  end
end
