# frozen_string_literal: true

require "test_helper"

# Switch's checked value is plain `value:` (0.16.0 — it was `checked_value:`
# through 0.15.0), and its hidden unchecked field carries the same guards
# Checkbox's does.
class SwitchValueTest < Minitest::Test
  include RenderHelper

  def test_switch_defaults_the_checked_value_to_one
    html = render(PhlexKit::Switch.new(name: "beta"))
    assert_includes html, %(value="1")
  end

  def test_switch_caller_value_replaces_the_default_without_fusing
    html = render(PhlexKit::Switch.new(name: "beta", value: "yes"))
    assert_includes html, %(value="yes")
    refute_includes html, %(value="1 yes")
    refute_includes html, %(value="yes 1")
  end

  # An unchecked "0" in a collection param injects a bogus element — Checkbox
  # already skips the hidden field for array names; Switch must too.
  def test_switch_omits_the_hidden_field_for_array_names
    html = render(PhlexKit::Switch.new(name: "ids[]"))
    refute_includes html, %(type="hidden")
  end

  # A form-attributed switch outside its <form> must post the unchecked value
  # to that same form (Rails' check_box idiom, already in Checkbox).
  def test_switch_hidden_field_carries_the_form_attribute
    html = render(PhlexKit::Switch.new(name: "beta", form: "settings"))
    assert_match(/<input type="hidden"[^>]*form="settings"/, html)
  end
end
