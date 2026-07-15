# frozen_string_literal: true

require "test_helper"
require "nokogiri"

# Audit round 5 (toast + toggle_group): numeric spacing must actually set the
# gap, toast radius must derive from --pk-radius, the toggle-group controller
# must announce selection changes, and the joined-corner rules must be
# logical-property based (RTL).
class Audit5ToastToggleTest < Minitest::Test
  include RenderHelper

  ROOT = File.expand_path("../..", __dir__)
  TOGGLE_GROUP_CSS = File.join(ROOT, "app/components/phlex_kit/toggle_group/toggle_group.css")
  TOGGLE_GROUP_JS = File.join(ROOT, "app/components/phlex_kit/toggle_group/toggle_group_controller.js")
  TOAST_CSS = File.join(ROOT, "app/components/phlex_kit/toast/toast.css")
  TOAST_JS = File.join(ROOT, "app/components/phlex_kit/toast/toast_controller.js")

  # --- Finding 5: spacing: N was stamped into data-spacing but the CSS only
  # knew the boolean .spaced class (fixed .25rem gap). The numeric value must
  # reach the gap via a --pk-toggle-group-gap custom property.
  def test_numeric_spacing_sets_gap_custom_property
    html = render(PhlexKit::ToggleGroup.new(spacing: 2) do |g|
      g.ToggleGroupItem(value: "a") { "A" }
    end)
    node = Nokogiri::HTML5.fragment(html).at_css(".pk-toggle-group")
    assert_includes node["class"], "spaced"
    assert_includes node["style"], "--pk-toggle-group-gap: 0.5rem;"
  end

  # The inline style must end with ";" — Phlex's mix joins duplicate string
  # attrs with a space, so a caller style: lands right after ours.
  def test_spacing_style_merges_with_caller_style
    html = render(PhlexKit::ToggleGroup.new(spacing: 1, style: "color: red;") do |g|
      g.ToggleGroupItem(value: "a") { "A" }
    end)
    node = Nokogiri::HTML5.fragment(html).at_css(".pk-toggle-group")
    assert_includes node["style"], "--pk-toggle-group-gap: 0.25rem; color: red;"
  end

  def test_zero_spacing_renders_no_gap_style_and_no_spaced_class
    html = render(PhlexKit::ToggleGroup.new do |g|
      g.ToggleGroupItem(value: "a") { "A" }
    end)
    node = Nokogiri::HTML5.fragment(html).at_css(".pk-toggle-group")
    refute_includes node["class"], "spaced"
    refute_includes node["style"].to_s, "--pk-toggle-group-gap"
  end

  def test_toggle_group_css_gap_reads_the_custom_property
    assert_includes File.read(TOGGLE_GROUP_CSS), "gap: var(--pk-toggle-group-gap, .25rem)"
  end

  # --- Finding 6: select() must announce the change like Toggle does.
  def test_toggle_group_controller_dispatches_change_event
    assert_includes File.read(TOGGLE_GROUP_JS), %{this.dispatch("change"}
  end

  # --- Finding 7 (RTL): joined corner rounding must use logical properties.
  def test_toggle_group_css_uses_logical_corner_radii
    css = File.read(TOGGLE_GROUP_CSS)
    %w[border-top-left-radius border-top-right-radius
       border-bottom-left-radius border-bottom-right-radius].each do |physical|
      refute_includes css, physical, "#{physical} should be a logical border-*-radius"
    end
    assert_includes css, "border-start-start-radius"
    assert_includes css, "border-end-end-radius"
  end

  # --- Finding 8: the two `:not(.spaced) .pk-toggle-group-item` rules
  # (padding + radius reset) must be merged into one.
  def test_toggle_group_css_has_single_joined_item_rule
    css = File.read(TOGGLE_GROUP_CSS)
    assert_equal 1, css.scan(".pk-toggle-group:not(.spaced) .pk-toggle-group-item {").size
  end

  # --- Finding 3: .pk-toast's 1rem radius must derive from --pk-radius like
  # every other radius in the file (1rem == var(--pk-radius) + 6px at the
  # default 0.625rem token).
  def test_toast_radius_derives_from_radius_token
    css = File.read(TOAST_CSS)
    refute_includes css, "border-radius: 1rem"
    assert_includes css, "border-radius: calc(var(--pk-radius) + 6px)"
  end

  # --- Finding 4: the 200ms unmount timeout must be cleared on disconnect.
  def test_toast_controller_tracks_and_clears_unmount_timer
    js = File.read(TOAST_JS)
    assert_includes js, "this._unmountTimer = setTimeout"
    assert_match(/disconnect\(\)\s*\{(?:[^}]*\n)*?.*clearTimeout\(this\._unmountTimer\)/, js)
  end
end
