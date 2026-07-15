# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 5 — misc cluster A: collapsible announces expanded state on the
# nested button (not the wrapper), and a server-rendered form-field error is
# aria-wired on connect (before any input/change).
class Audit5MiscASystemTest < SystemTestCase
  include InteractionHelpers

  def test_collapsible_announces_state_on_the_nested_button
    visit "/docs/collapsible"
    section = demo("Basic")
    # Wait for connect (it stamps the closed state and relocates the aria).
    section.assert_selector ".pk-collapsible[data-state='closed']"

    button = section.find(".pk-collapsible-trigger button")
    wrapper = section.find(".pk-collapsible-trigger")
    content = section.find(".pk-collapsible-content", visible: :all)

    # The focusable control carries the state + relationship; the plain
    # wrapper div no longer carries a stale aria-expanded of its own.
    assert_equal "false", button["aria-expanded"]
    assert_equal content[:id], button["aria-controls"]
    assert_nil wrapper["aria-expanded"]

    button.click
    section.assert_selector ".pk-collapsible-trigger button[aria-expanded='true']"
    section.assert_selector ".pk-collapsible-content:not(.pk-hidden)"
    assert_nil wrapper["aria-expanded"]

    button.click
    section.assert_selector ".pk-collapsible-trigger button[aria-expanded='false']"
    section.assert_selector ".pk-collapsible-content.pk-hidden", visible: :all
  end

  def test_server_rendered_form_field_error_is_aria_wired_on_connect
    visit "/docs/form"
    section = demo("Server-rendered error")
    field = section.find(".pk-form-field:has(#form-handle)")
    input = field.find("#form-handle")
    error = field.find(".pk-form-field-error", text: "Handle is already taken.")

    # No input/change/invalid has fired — connect alone must wire the aria.
    assert_equal "true", input["aria-invalid"]
    assert_includes input["aria-describedby"].to_s.split, error[:id]

    # And validation is armed: typing a valid value live-clears everything.
    input.send_keys "handle"
    field.assert_selector ".pk-form-field-error.pk-hidden", visible: :all
    refute_includes input["aria-describedby"].to_s.split, error[:id]
    assert_nil input["aria-invalid"]
  end
end
