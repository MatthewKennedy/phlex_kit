# frozen_string_literal: true

require "test_helper"
require "nokogiri"

# Audit round 7: CSS/misc mediums batch — five independent small fixes.
class Audit7CssMiscTest < Minitest::Test
  include RenderHelper

  ROOT = File.expand_path("../..", __dir__)
  ATTACHMENT_CSS = File.join(ROOT, "app/components/phlex_kit/attachment/attachment.css")
  NATIVE_SELECT_CSS = File.join(ROOT, "app/components/phlex_kit/native_select/native_select.css")
  BREADCRUMB_CSS = File.join(ROOT, "app/components/phlex_kit/breadcrumb/breadcrumb.css")
  KBD_CSS = File.join(ROOT, "app/components/phlex_kit/kbd/kbd.css")
  ITEM_CSS = File.join(ROOT, "app/components/phlex_kit/item/item.css")
  MARKER_CSS = File.join(ROOT, "app/components/phlex_kit/marker/marker.css")

  # --- Finding 2: attachment's shimmer re-implements .pk-shimmer inline
  # (upload-state title) without _tokens.css's reduced-motion / no-oklch
  # fallback arms — the filename renders invisible on Safari <16.4/Chrome
  # <119 (no relative color syntax) and keeps sweeping under
  # prefers-reduced-motion: reduce.
  def test_attachment_shimmer_honors_reduced_motion
    css = File.read(ATTACHMENT_CSS)
    block = css[/@media \(prefers-reduced-motion: reduce\)\s*\{.*?\.pk-attachment\[data-state="uploading"\][^}]*\}\s*\}/m]
    refute_nil block, "attachment.css must disable the upload-title shimmer under prefers-reduced-motion: reduce"
    assert_includes block, "-webkit-text-fill-color: currentColor"
  end

  def test_attachment_shimmer_has_no_oklch_fallback
    css = File.read(ATTACHMENT_CSS)
    block = css[/@supports not \(color: oklch\(from white l c h\)\)\s*\{.*?\.pk-attachment\[data-state="uploading"\][^}]*\}\s*\}/m]
    refute_nil block, "attachment.css must fall back to plain text where relative color syntax is unsupported"
    assert_includes block, "-webkit-text-fill-color: currentColor"
  end

  # --- Finding 3: native_select doesn't style the native [size]/[multiple]
  # list-box form — the fixed 2rem height squashes it and the absolute
  # chevron overlays the option list.
  def test_native_select_list_box_size_passes_through
    html = render(PhlexKit::NativeSelect.new(size: 5, name: "store_id"))
    node = Nokogiri::HTML5.fragment(html).at_css("select")
    assert_equal "5", node["size"]
  end

  def test_native_select_dropdown_size_1_passes_through
    html = render(PhlexKit::NativeSelect.new(size: 1, name: "store_id"))
    node = Nokogiri::HTML5.fragment(html).at_css("select")
    assert_equal "1", node["size"]
  end

  def test_native_select_css_has_size_and_multiple_arms
    css = File.read(NATIVE_SELECT_CSS)
    assert_match(/\.pk-native-select-field\[size\]:not\(\[size="1"\]\)/, css, "native_select.css must style the [size] list-box form with :not([size=\"1\"]) exclusion")
    assert_match(/\.pk-native-select-field\[multiple\]/, css, "native_select.css must style the [multiple] list-box form")
  end

  def test_native_select_list_box_hides_chevron
    css = File.read(NATIVE_SELECT_CSS)
    # The chevron icon sits in a sibling .pk-native-select-icon — a [size] or
    # [multiple] select must hide it via the wrapper (list boxes have no
    # single-line row for the chevron to sit in). size="1" is excluded (it's a
    # single-line dropdown, not a list box).
    assert_match(/:has\(.*\[size\]:not\(\[size="1"\]\)\)/, css, "native_select.css must hide the chevron for list-box selects (excluding size=1)")
    assert_match(/:has\(.*\[multiple\]\)/, css, "native_select.css must hide the chevron for [multiple] selects")
  end

  # --- Finding 4: breadcrumb list needs the UA <ol>/<ul> reset (pattern:
  # pagination.css's .pk-pagination-content).
  def test_breadcrumb_list_resets_ua_list_styles
    css = File.read(BREADCRUMB_CSS)
    rule = css[/\.pk-breadcrumb-list\s*\{[^}]*\}/m]
    refute_nil rule
    assert_match(/list-style:\s*none/, rule)
    assert_match(/margin:\s*0/, rule)
    assert_match(/padding:\s*0/, rule)
  end

  # --- Finding 5: kbd/item/marker svg guards use the Tailwind-leftover
  # :not([class*="size-"]) selector, which never matches (no `size-*`
  # classes exist in this kit) — so Icon size: never actually wins. Pattern
  # + rationale at button.css:39: :not([width]).
  def test_kbd_svg_guard_uses_not_width
    css = File.read(KBD_CSS)
    refute_match(/:not\(\[class\*="size-"\]\)/, css)
    assert_match(/\.pk-kbd svg:not\(\[width\]\)/, css)
  end

  def test_item_svg_guard_uses_not_width
    css = File.read(ITEM_CSS)
    refute_match(/:not\(\[class\*="size-"\]\)/, css)
    assert_match(/\.pk-item-media\.icon svg:not\(\[width\]\)/, css)
  end

  def test_marker_svg_guard_uses_not_width
    css = File.read(MARKER_CSS)
    refute_match(/:not\(\[class\*="size-"\]\)/, css)
    assert_match(/\.pk-marker svg:not\(\[width\]\)/, css)
  end
end
