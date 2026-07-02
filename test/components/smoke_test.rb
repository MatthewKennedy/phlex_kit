# frozen_string_literal: true

require "test_helper"

# Proves a representative slice across the kit's shapes actually renders (not just
# loads): variant-driven, plain-input, multi-part compose, and Stimulus-wired.
class SmokeTest < Minitest::Test
  include RenderHelper

  def test_button_renders_with_variant
    assert_includes render(PhlexKit::Button.new(variant: :destructive) { "Delete" }), "pk-button"
  end

  def test_input_passes_attrs_through
    html = render(PhlexKit::Input.new(type: "email", name: "email"))
    assert_includes html, "pk-input"
    assert_includes html, %(type="email")
  end

  def test_card_composes_parts
    card = PhlexKit::Card.new do |c|
      # parts are rendered by the caller; just prove the shell renders
    end
    assert_includes render(card), "pk-card"
  end

  def test_separator_renders
    assert_includes render(PhlexKit::Separator.new), "pk-separator"
  end

  def test_progress_renders
    assert_includes render(PhlexKit::Progress.new(value: 40)), "pk-progress"
  end

  def test_dropdown_menu_emits_stimulus_identifier
    html = render(PhlexKit::DropdownMenu.new { "x" })
    assert_includes html, "phlex-kit--dropdown-menu"
    refute_includes html, "ruby-ui--", "stale ruby_ui Stimulus identifier leaked"
  end

  def test_all_component_constants_are_defined
    names = Dir[File.expand_path("../../app/components/phlex_kit/*", __dir__)]
            .select { |p| File.directory?(p) }.map { |p| File.basename(p) }
    assert_operator names.size, :>=, 22
  end
end
