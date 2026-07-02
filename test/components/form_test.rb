# frozen_string_literal: true

require "test_helper"

# Form — the full ruby_ui form layer: Form shell + FormField live validation
# (phlex-kit--form-field), with the kit's controls registered as input targets.
class FormTest < Minitest::Test
  include RenderHelper

  def test_form_renders_pk_form
    html = render(PhlexKit::Form.new(action: "/reviews", method: "post") { "x" })
    assert_includes html, "<form"
    assert_includes html, "pk-form"
    assert_includes html, %(action="/reviews")
  end

  def test_form_field_carries_the_controller
    assert_includes render(PhlexKit::FormField.new { "x" }), %(data-controller="phlex-kit--form-field")
  end

  def test_form_field_error_is_a_target
    html = render(PhlexKit::FormFieldError.new)
    assert_includes html, %(data-phlex-kit--form-field-target="error")
    assert_includes html, "pk-form-field-error"
  end

  def test_input_and_textarea_register_as_input_targets
    input = render(PhlexKit::Input.new(name: "email", required: true))
    assert_includes input, %(data-phlex-kit--form-field-target="input")
    assert_includes input, "invalid->phlex-kit--form-field#onInvalid"
    textarea = render(PhlexKit::Textarea.new(name: "body") { "hi" })
    assert_includes textarea, "input->phlex-kit--form-field#onInput"
  end

  def test_choice_controls_validate_on_change
    assert_includes render(PhlexKit::Checkbox.new(name: "tos")), "change->phlex-kit--form-field#onInput"
    assert_includes render(PhlexKit::RadioButton.new(name: "r", value: "1")), "change->phlex-kit--form-field#onInput"
    assert_includes render(PhlexKit::NativeSelect.new(name: "s") { }), "change->phlex-kit--form-field#onChange"
    assert_includes render(PhlexKit::SelectInput.new(name: "sel")), "change->phlex-kit--form-field#onChange"
  end

  def test_caller_attrs_still_pass_through
    html = render(PhlexKit::Input.new(name: "email", data: { foo: "bar" }))
    assert_includes html, %(data-foo="bar")
    assert_includes html, %(data-phlex-kit--form-field-target="input")
  end
end
