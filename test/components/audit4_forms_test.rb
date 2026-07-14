# frozen_string_literal: true

require "test_helper"

# Audit round 4 — forms cluster: input_otp, form_field, collapsible, tabs,
# input_group, field. (The harness can't nest `render`, so multi-part
# components are rendered part-by-part.)
class Audit4FormsTest < Minitest::Test
  include RenderHelper

  # --- input_otp ---

  def test_otp_hidden_input_carries_server_value
    html = render(PhlexKit::InputOtp.new(name: "otp", value: "123456"))
    assert_includes html, %(type="hidden")
    assert_includes html, %(value="123456")
  end

  def test_otp_separator_is_decorative
    html = render(PhlexKit::InputOtpSeparator.new)
    assert_includes html, %(aria-hidden="true")
    refute_includes html, %(role="separator")
  end

  # --- form_field ---

  def test_form_field_error_generates_a_unique_id
    html = render(PhlexKit::FormFieldError.new)
    assert_match(/id="pk-form-field-error-\h{8}"/, html)
    other = render(PhlexKit::FormFieldError.new)
    refute_equal html[/id="([^"]+)"/, 1], other[/id="([^"]+)"/, 1]
  end

  def test_form_field_error_respects_caller_id
    html = render(PhlexKit::FormFieldError.new(id: "my-error"))
    assert_includes html, %(id="my-error")
    refute_match(/pk-form-field-error-\h{8}/, html)
  end

  # --- collapsible ---

  def test_collapsible_trigger_renders_aria_expanded
    closed = render(PhlexKit::CollapsibleTrigger.new { "Toggle" })
    assert_includes closed, %(aria-expanded="false")
    assert_includes closed, %(data-phlex-kit--collapsible-target="trigger")
    open = render(PhlexKit::CollapsibleTrigger.new(open: true) { "Toggle" })
    assert_includes open, %(aria-expanded="true")
  end

  def test_collapsible_content_hidden_when_closed
    closed = render(PhlexKit::CollapsibleContent.new { "Body" })
    assert_includes closed, "pk-hidden"
    assert_match(/id="pk-collapsible-content-\h{8}"/, closed)
    open = render(PhlexKit::CollapsibleContent.new(open: true) { "Body" })
    refute_includes open, "pk-hidden"
  end

  def test_collapsible_content_respects_caller_id
    html = render(PhlexKit::CollapsibleContent.new(id: "faq-1") { "Body" })
    assert_includes html, %(id="faq-1")
  end

  # --- tabs ---

  def test_tabs_content_active_kwarg_controls_prejs_visibility
    inactive = render(PhlexKit::TabsContent.new(value: "a") { "A" })
    assert_includes inactive, "pk-hidden"
    active = render(PhlexKit::TabsContent.new(value: "a", active: true) { "A" })
    refute_includes active, "pk-hidden"
    assert_includes active, %(role="tabpanel")
  end

  # --- input_group ---

  def test_input_group_addon_has_no_group_role
    html = render(PhlexKit::InputGroupAddon.new { "$" })
    refute_includes html, %(role="group")
    assert_includes html, "pk-input-group-addon"
    # the group shell itself keeps its role
    assert_includes render(PhlexKit::InputGroup.new { "x" }), %(role="group")
  end

  # --- field ---

  def test_field_error_renders_both_errors_and_block
    html = render(PhlexKit::FieldError.new(errors: [ "Too short.", "Needs a number." ]) { "See the rules." })
    assert_includes html, "<li>Too short.</li>"
    assert_includes html, "See the rules."
    single = render(PhlexKit::FieldError.new(errors: [ "Too short." ]) { "See the rules." })
    assert_includes single, "Too short."
    assert_includes single, "See the rules."
  end
end
