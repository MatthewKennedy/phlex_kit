# frozen_string_literal: true

require "test_helper"
require "nokogiri"

# Audit round 6, phase 4: RTL fixes that Cuprite (Chromium-only, and some
# pseudo-element geometry) can't observe directly — guarded mechanically.
# Only sidebar's physical pinning and resizable's drag math are documented
# RTL exemptions; everything else must use logical properties or ship an
# explicit :dir(rtl) arm.
class Audit6RtlTest < Minitest::Test
  include RenderHelper

  def css(component, file = component)
    File.read(File.expand_path("../../app/components/phlex_kit/#{component}/#{file}.css", __dir__))
  end

  # --- progress: the indicator was translated by a physical inline style
  # (translateX(-N%)), filling from the wrong side in RTL and leaking float
  # artifacts ("40.0") into the ARIA attributes.
  def test_progress_exposes_value_as_custom_property_not_inline_transform
    html = render(PhlexKit::Progress.new(value: 40))
    root = Nokogiri::HTML5.fragment(html).at_css(".pk-progress")
    assert_includes root["style"], "--pk-progress-value: 40;"
    indicator = root.at_css(".pk-progress-indicator")
    refute_includes indicator["style"].to_s, "translateX"
  end

  def test_progress_aria_values_format_without_float_artifacts
    html = render(PhlexKit::Progress.new(value: 40))
    root = Nokogiri::HTML5.fragment(html).at_css(".pk-progress")
    assert_equal "40", root["aria-valuenow"]
    assert_equal "40%", root["aria-valuetext"]
  end

  def test_progress_value_text_kwarg_replaces_default_unfused
    html = render(PhlexKit::Progress.new(value: 75, value_text: "Step 3 of 4"))
    root = Nokogiri::HTML5.fragment(html).at_css(".pk-progress")
    assert_equal "Step 3 of 4", root["aria-valuetext"]
  end

  def test_progress_css_translates_indicator_from_the_custom_property_with_rtl_arm
    content = css("progress")
    assert_match(/\.pk-progress-indicator\s*\{[^}]*var\(--pk-progress-value/m, content,
      "indicator transform must derive from --pk-progress-value")
    assert_match(/:dir\(rtl\)/, content, "progress.css needs an RTL fill-direction arm")
  end

  # --- slider: the WebKit filled-track gradient hardcoded `to right`;
  # Chrome mirrors the control in RTL but kept painting the fill from the
  # physical left (anchored at the max end).
  def test_slider_css_has_rtl_gradient_arm
    content = css("slider")
    assert_match(/:dir\(rtl\)[^{]*::-webkit-slider-runnable-track\s*\{[^}]*to left/m, content,
      "slider.css needs a :dir(rtl) `to left` gradient for the WebKit track fill")
  end

  # --- hover_card: .left/.right paired logical position-area with physical
  # gap margins, putting the .25rem gap on the wrong side in RTL. Tooltip
  # already does this correctly with margin-inline-end/-start.
  def test_hover_card_side_gaps_are_logical
    content = css("hover_card")
    left = content[/\.pk-hover-card-content\.left\s*\{[^}]*\}/m]
    right = content[/\.pk-hover-card-content\.right\s*\{[^}]*\}/m]
    assert_match(/margin-inline-end/, left, ".left gap must be margin-inline-end (matches tooltip)")
    assert_match(/margin-inline-start/, right, ".right gap must be margin-inline-start (matches tooltip)")
    refute_match(/margin:\s*0\s+\.25rem\s+0\s+0/, left)
    refute_match(/margin:\s*0\s+0\s+0\s+\.25rem/, right)
  end

  # --- dropdown_menu: same physical-margin-vs-logical-position-area mismatch
  # on the side-placed panels.
  def test_dropdown_menu_side_gaps_are_logical
    content = css("dropdown_menu")
    right = content[/\.pk-dropdown-menu-content-right\s*\{[^}]*\}/m]
    left = content[/\.pk-dropdown-menu-content-left\s*\{[^}]*\}/m]
    assert_match(/margin-inline-start/, right)
    assert_match(/margin-inline-end/, left)
    refute_match(/margin:\s*0\s+0\s+0\s+4px/, right)
    refute_match(/margin:\s*0\s+4px\s+0\s+0/, left)
  end

  # --- select: the item's 2rem check-mark gutter and the trigger's
  # asymmetric padding were physical while the check icon is placed with
  # inset-inline-end — in RTL the check overlapped the label text.
  def test_select_item_and_trigger_paddings_are_logical
    content = css("select")
    refute_match(/padding:\s*\.25rem\s+2rem\s+\.25rem\s+\.375rem/, content,
      "select item padding must use padding-inline so the check gutter follows inset-inline-end")
    refute_match(/padding:\s*\.25rem\s+\.5rem\s+\.25rem\s+\.625rem/, content,
      "select trigger padding must use padding-inline")
    assert_match(/padding-inline:\s*\.375rem\s+2rem/, content)
    assert_match(/padding-inline:\s*\.625rem\s+\.5rem/, content)
  end
end
