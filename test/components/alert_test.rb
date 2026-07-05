# frozen_string_literal: true

require "test_helper"

class AlertTest < Minitest::Test
  include RenderHelper

  def test_default_renders_role_alert_and_base_class
    html = render(PhlexKit::Alert.new { "body" })
    assert_includes html, "pk-alert"
    assert_includes html, %(role="alert")
    refute_includes html, "destructive"
  end

  def test_variant_modifiers
    assert_includes render(PhlexKit::Alert.new(variant: :destructive) { "x" }), "destructive"
    assert_includes render(PhlexKit::Alert.new(variant: :success) { "x" }), "success"
    assert_includes render(PhlexKit::Alert.new(variant: :warning) { "x" }), "warning"
  end

  def test_unknown_variant_fails_loud
    assert_raises(KeyError) { render(PhlexKit::Alert.new(variant: :nope) { "x" }) }
  end

  def test_title_is_a_div
    html = render(PhlexKit::AlertTitle.new { "Heads up" })
    assert_includes html, "pk-alert-title"
    assert_includes html, "<div"
    refute_includes html, "<h5"
  end

  def test_description
    html = render(PhlexKit::AlertDescription.new { "Details" })
    assert_includes html, "pk-alert-description"
    assert_includes html, "Details"
  end

  def test_action
    html = render(PhlexKit::AlertAction.new { "Undo" })
    assert_includes html, "pk-alert-action"
    assert_includes html, "Undo"
  end

  def test_caller_class_is_merged_not_clobbered
    html = render(PhlexKit::Alert.new(class: "extra") { "x" })
    assert_includes html, "pk-alert"
    assert_includes html, "extra"
  end
end
