# frozen_string_literal: true

require "test_helper"

# Wave 2 — Stimulus-driven components ported from ruby_ui.
class Wave2Test < Minitest::Test
  include RenderHelper

  def test_accordion_item_wires_controller_and_open_value
    html = render(PhlexKit::AccordionItem.new(open: true) { "x" })
    assert_includes html, "phlex-kit--accordion"
    assert_includes html, "accordion-open-value"
  end

  def test_accordion_content_starts_hidden
    html = render(PhlexKit::AccordionContent.new { "body" })
    assert_includes html, "hidden"
    assert_includes html, "phlex-kit--accordion-target"
  end

  def test_collapsible_controller
    assert_includes render(PhlexKit::Collapsible.new { "x" }), "phlex-kit--collapsible"
  end

  def test_tabs_trigger_and_content
    assert_includes render(PhlexKit::TabsTrigger.new(value: "a") { "A" }), "click->phlex-kit--tabs#show"
    assert_includes render(PhlexKit::TabsContent.new(value: "a") { "p" }), "pk-hidden"
  end

  def test_toggle_variant_size_and_hidden_input
    html = render(PhlexKit::Toggle.new(variant: :outline, size: :sm, name: "b", pressed: true) { "B" })
    assert_includes html, "outline"
    assert_includes html, "sm"
    assert_includes html, %(type="hidden")
    assert_includes html, %(aria-pressed="true")
  end

  def test_toggle_group_single_is_radiogroup_with_one_pressed
    html = render(PhlexKit::ToggleGroup.new(type: :single, name: "g", value: "y") do |g|
      g.ToggleGroupItem(value: "x") { "X" }
      g.ToggleGroupItem(value: "y") { "Y" }
    end)
    assert_includes html, %(role="radiogroup")
    assert_includes html, "phlex-kit--toggle-group"
    assert_equal 1, html.scan(/data-state="on"/).size
  end

  def test_toggle_group_multiple_posts_array
    html = render(PhlexKit::ToggleGroup.new(type: :multiple, name: "m", value: %w[x]) do |g|
      g.ToggleGroupItem(value: "x") { "X" }
    end)
    assert_includes html, "m[]"
  end
end
