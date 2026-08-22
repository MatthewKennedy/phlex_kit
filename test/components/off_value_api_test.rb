# frozen_string_literal: true

require "test_helper"

# "What posts when this control is off" is spelled `unchecked_value:` kit-wide
# (0.16.0 — Toggle called it `unpressed_value:` through 0.15.0), and every
# hidden-field emitter takes `include_hidden:`.
class OffValueApiTest < Minitest::Test
  include RenderHelper

  OFF_VALUE_COMPONENTS = [ PhlexKit::Checkbox, PhlexKit::Switch, PhlexKit::Toggle ].freeze

  def test_all_off_value_components_accept_unchecked_value
    OFF_VALUE_COMPONENTS.each do |klass|
      params = klass.instance_method(:initialize).parameters
      assert_includes params, [ :key, :unchecked_value ], "#{klass} lacks unchecked_value:"
    end
  end

  def test_all_off_value_components_accept_include_hidden
    OFF_VALUE_COMPONENTS.each do |klass|
      params = klass.instance_method(:initialize).parameters
      assert_includes params, [ :key, :include_hidden ], "#{klass} lacks include_hidden:"
    end
  end

  def test_toggle_posts_the_unchecked_value_when_off
    html = render(PhlexKit::Toggle.new(name: "bold", value: "1", unchecked_value: "0")) { "B" }
    assert_match(/<input type="hidden"[^>]*value="0"/, html)
  end

  def test_toggle_include_hidden_false_omits_the_field
    html = render(PhlexKit::Toggle.new(name: "bold", include_hidden: false)) { "B" }
    refute_includes html, %(type="hidden")
  end

  # Same fail-loud migration guard Switch got: the old kwarg would otherwise
  # land in **attrs and render a bogus unpressed_value="…" attribute.
  def test_toggle_rejects_the_old_unpressed_value_kwarg
    error = assert_raises(ArgumentError) { PhlexKit::Toggle.new(unpressed_value: "0") }
    assert_match(/unchecked_value:/, error.message)
  end
end
