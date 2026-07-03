# frozen_string_literal: true

require "test_helper"

# PhlexKit::Icon + the PhlexKit::Icons registry (lib/phlex_kit/icons/).
class IconTest < Minitest::Test
  include RenderHelper

  def teardown
    PhlexKit.config.icon_library = :lucide
  end

  def test_every_canonical_glyph_resolves_in_every_library
    PhlexKit::Icons::MODULES.each_key do |library|
      PhlexKit::Icons.names.each do |name|
        icon = PhlexKit::Icons.fetch(name, library: library)
        refute_empty icon[:elements], "#{library}/#{name} has no geometry"
      end
    end
  end

  def test_stroke_library_renders_stroke_attrs
    html = render(PhlexKit::Icon.new(:check))
    assert_includes html, "pk-icon"
    assert_includes html, %(stroke="currentColor")
    assert_includes html, %(stroke-width="2")
    assert_includes html, %(fill="none")
    assert_includes html, %(viewbox="0 0 24 24")
    assert_includes html, %(aria-hidden="true")
  end

  def test_fill_library_renders_fill_attrs
    html = render(PhlexKit::Icon.new(:check, library: :phosphor))
    assert_includes html, %(fill="currentColor")
    assert_includes html, %(viewbox="0 0 256 256")
    refute_includes html, "stroke-width"
  end

  def test_default_size_is_16
    html = render(PhlexKit::Icon.new(:x))
    assert_includes html, %(width="16")
    assert_includes html, %(height="16")
  end

  def test_size_nil_defers_to_css
    html = render(PhlexKit::Icon.new(:x, size: nil))
    refute_match(/\swidth=/, html)
    refute_match(/\sheight=/, html)
  end

  def test_config_switches_the_default_library
    PhlexKit.config.icon_library = :remix
    html = render(PhlexKit::Icon.new(:check))
    assert_includes html, %(fill="currentColor")
  end

  def test_unknown_glyph_fails_loud
    assert_raises(KeyError) { render(PhlexKit::Icon.new(:bogus)) }
  end

  def test_unknown_library_fails_loud
    assert_raises(KeyError) { render(PhlexKit::Icon.new(:check, library: :hugeicons)) }
  end

  def test_attrs_pass_through_mix
    html = render(PhlexKit::Icon.new(:check, class: "extra", data: { x: "1" }))
    assert_includes html, "pk-icon extra"
    assert_includes html, %(data-x="1")
  end

  def test_spinner_keeps_status_role_without_aria_hidden
    html = render(PhlexKit::Spinner.new)
    assert_includes html, "pk-spinner"
    assert_includes html, %(role="status")
    refute_includes html, "aria-hidden"
  end

  def test_toast_icon_maps_variants
    html = render(PhlexKit::ToastIcon.new(variant: :loading))
    assert_includes html, "pk-toast-icon-svg spin"
    assert_includes html, "pk-icon"
  end
end
