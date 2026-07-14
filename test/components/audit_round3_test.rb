# frozen_string_literal: true

require "test_helper"

# Audit round 3 — Ruby-side contracts: fail-loud option maps, **mix on the
# root element, input validation, and live-region wiring for form errors.
class AuditRound3Test < Minitest::Test
  include RenderHelper

  # Toggle.modifier_classes used fetch(x, nil), silently swallowing unknown
  # variants/sizes against the kit's fail-loud rule.
  def test_toggle_unknown_variant_fails_loud
    assert_raises(KeyError) { render(PhlexKit::Toggle.new(variant: :nope) { "B" }) }
    assert_raises(KeyError) { render(PhlexKit::Toggle.new(size: :nope) { "B" }) }
  end

  def test_toggle_group_item_unknown_variant_fails_loud
    ctx = { selected_values: [], variant: :default, size: :default, disabled: false }
    assert_raises(KeyError) { render(PhlexKit::ToggleGroupItem.new(value: "a", group_context: ctx, variant: :nope) { "A" }) }
  end

  def test_toggle_known_options_still_render
    html = render(PhlexKit::Toggle.new(variant: :outline, size: :lg) { "B" })
    assert_includes html, "outline"
    assert_includes html, "lg"
  end

  # AspectRatio applied **mix to the inner div — caller attrs never reached
  # the root element, the only **mix violation in the kit.
  def test_aspect_ratio_mixes_caller_attrs_onto_the_root
    html = render(PhlexKit::AspectRatio.new(aspect_ratio: "16/9", class: "hero", data: { x: "y" }) { "img" })
    assert_includes html, %(class="pk-aspect-ratio hero")
    assert_includes html, %(data-x="y")
  end

  def test_aspect_ratio_rejects_zero_and_non_numeric_terms
    assert_raises(ArgumentError) { PhlexKit::AspectRatio.new(aspect_ratio: "16/0") }
    assert_raises(ArgumentError) { PhlexKit::AspectRatio.new(aspect_ratio: "a/b") }
    assert_raises(ArgumentError) { PhlexKit::AspectRatio.new(aspect_ratio: "16") }
  end

  # The live-updated validation message must be announced: role="alert" also
  # gives the red text an implicit assertive live region.
  def test_form_field_error_is_a_live_region
    html = render(PhlexKit::FormFieldError.new)
    assert_includes html, %(role="alert")
  end

  # A server-rendered open item must be readable without JS: the hardcoded
  # hidden + height:0 made its content permanently unreachable pre-hydration.
  def test_accordion_content_open_renders_visible
    html = render(PhlexKit::AccordionContent.new(open: true) { "Body" })
    refute_includes html, "hidden"
    refute_includes html, "height: 0px"
    assert_includes html, %(data-state="open")
  end

  def test_accordion_content_defaults_to_closed
    html = render(PhlexKit::AccordionContent.new { "Body" })
    assert_includes html, "hidden"
    assert_includes html, %(data-state="closed")
  end
end
