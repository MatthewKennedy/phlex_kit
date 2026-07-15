# frozen_string_literal: true

require "test_helper"

class FieldTest < Minitest::Test
  include RenderHelper

  def test_field_default_vertical
    html = render(PhlexKit::Field.new { "x" })
    assert_includes html, "pk-field"
    assert_includes html, %(data-orientation="vertical")
    assert_includes html, %(role="group")
    refute_includes html, "data-invalid"
  end

  def test_field_orientations_and_states
    assert_includes render(PhlexKit::Field.new(orientation: :horizontal) { "x" }), %(data-orientation="horizontal")
    assert_includes render(PhlexKit::Field.new(orientation: :responsive) { "x" }), %(data-orientation="responsive")
    html = render(PhlexKit::Field.new(invalid: true, disabled: true) { "x" })
    assert_includes html, %(data-invalid="true")
    assert_includes html, %(data-disabled="true")
    assert_raises(KeyError) { render(PhlexKit::Field.new(orientation: :diagonal) { "x" }) }
  end

  def test_field_set_and_legend
    assert_includes render(PhlexKit::FieldSet.new { "x" }), "<fieldset"
    assert_includes render(PhlexKit::FieldLegend.new { "Address" }), "pk-field-legend legend"
    assert_includes render(PhlexKit::FieldLegend.new(variant: :label) { "Plan" }), "pk-field-legend label"
    assert_raises(KeyError) { render(PhlexKit::FieldLegend.new(variant: :nope) { "x" }) }
  end

  def test_group_content_label_title_description
    assert_includes render(PhlexKit::FieldGroup.new { "x" }), "pk-field-group"
    assert_includes render(PhlexKit::FieldContent.new { "x" }), "pk-field-content"
    html = render(PhlexKit::FieldLabel.new(for: "a") { "Email" })
    assert_includes html, "pk-label pk-field-label"
    assert_includes html, %(for="a")
    assert_includes render(PhlexKit::FieldTitle.new { "x" }), "pk-field-title"
    assert_includes render(PhlexKit::FieldDescription.new { "x" }), "pk-field-description"
  end

  def test_separator_with_and_without_content
    plain = render(PhlexKit::FieldSeparator.new)
    refute_includes plain, "pk-field-separator-content"
    labeled = render(PhlexKit::FieldSeparator.new { "Or continue with" })
    assert_includes labeled, "pk-field-separator-content"
    assert_includes labeled, "Or continue with"
  end

  def test_error_states
    assert_equal "", render(PhlexKit::FieldError.new)
    single = render(PhlexKit::FieldError.new(errors: [ "Too short.", "Too short." ]))
    assert_includes single, %(role="alert")
    assert_includes single, "Too short."
    refute_includes single, "<ul"
    multi = render(PhlexKit::FieldError.new(errors: [ "Too short.", "Needs a number." ]))
    assert_includes multi, "pk-field-error-list"
    assert_includes multi, "<li>Needs a number.</li>"
  end
end
