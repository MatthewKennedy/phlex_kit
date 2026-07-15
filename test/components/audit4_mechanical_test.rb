# frozen_string_literal: true

require "test_helper"
require "nokogiri"

# Audit round 4 (mechanical pass): style-attr merging, disabled hidden inputs,
# heading level validation, aria-hidden/sr-only placement, decorative
# separators, scrollable-region focusability, and first render tests for
# Table/Checkbox/Link.
class Audit4MechanicalTest < Minitest::Test
  include RenderHelper

  # --- Finding 1: AspectRatio inline style must end with ";" so a caller
  # style: merges into two valid declarations (Phlex joins duplicates with a space).
  def test_aspect_ratio_style_merges_with_caller_style
    html = render(PhlexKit::AspectRatio.new(style: "background: red;") { })
    assert_includes html, "padding-bottom: 56.25%;"
    assert_includes html, "background: red;"
    assert_includes html, %(style="padding-bottom: 56.25%; background: red;")
  end

  # --- Finding 2: same for Slider's --pk-slider-progress declaration.
  def test_slider_style_merges_with_caller_style
    html = render(PhlexKit::Slider.new(style: "width: 50%;"))
    assert_includes html, %(style="--pk-slider-progress: 50.0%; width: 50%;")
  end

  # --- Finding 3: Heading level must be validated (h1–h6); 7 previously blew
  # up at render with NoMethodError, 5/6 silently fell through the size map.
  def test_heading_invalid_level_fails_loud
    error = assert_raises(ArgumentError) { PhlexKit::Heading.new(level: 7) }
    assert_match(/level/i, error.message)
    assert_raises(ArgumentError) { PhlexKit::Heading.new(level: 0) }
  end

  def test_heading_levels_one_through_six_render_matching_elements
    (1..6).each do |level|
      html = render(PhlexKit::Heading.new(level: level) { "T" })
      assert_includes html, "<h#{level}", "level #{level} should render h#{level}"
    end
  end

  def test_heading_levels_five_and_six_have_distinct_default_sizes
    h5 = render(PhlexKit::Heading.new(level: 5) { "T" })
    h6 = render(PhlexKit::Heading.new(level: 6) { "T" })
    assert_includes h5, "pk-heading-3"
    assert_includes h6, "pk-heading-2"
  end

  # --- Finding 4: a disabled Toggle must not submit its hidden input.
  def test_disabled_toggle_disables_hidden_input
    html = render(PhlexKit::Toggle.new(name: "opt", disabled: true) { "T" })
    hidden = Nokogiri::HTML5.fragment(html).at_css("input[type=hidden]")
    refute_nil hidden
    assert hidden.has_attribute?("disabled"), "hidden input should be disabled in lockstep with the button"
  end

  def test_enabled_toggle_hidden_input_not_disabled
    html = render(PhlexKit::Toggle.new(name: "opt") { "T" })
    hidden = Nokogiri::HTML5.fragment(html).at_css("input[type=hidden]")
    refute hidden.has_attribute?("disabled")
  end

  # --- Finding 5: same for Switch's hidden unchecked-value field (Rails'
  # check_box disables the pair in lockstep).
  def test_disabled_switch_disables_hidden_input
    html = render(PhlexKit::Switch.new(name: "on", disabled: true))
    hidden = Nokogiri::HTML5.fragment(html).at_css("input[type=hidden]")
    refute_nil hidden
    assert hidden.has_attribute?("disabled")
  end

  def test_enabled_switch_hidden_input_not_disabled
    html = render(PhlexKit::Switch.new(name: "on"))
    hidden = Nokogiri::HTML5.fragment(html).at_css("input[type=hidden]")
    refute hidden.has_attribute?("disabled")
  end

  # --- Finding 6: the sr-only text must not sit inside an aria-hidden
  # element, or it's never announced.
  def test_breadcrumb_ellipsis_sr_only_text_is_announced
    doc = Nokogiri::HTML5.fragment(render(PhlexKit::BreadcrumbEllipsis.new))
    sr = doc.at_css(".pk-sr-only")
    refute_nil sr
    assert_equal "More", sr.text
    # Phlex renders `aria: { hidden: true }` as a bare boolean attribute, so
    # check presence, not value.
    assert sr.ancestors.none? { |a| a.element? && a.has_attribute?("aria-hidden") },
      "sr-only span must not be a descendant of an aria-hidden element"
  end

  def test_pagination_ellipsis_sr_only_text_is_announced
    doc = Nokogiri::HTML5.fragment(render(PhlexKit::PaginationEllipsis.new))
    sr = doc.at_css(".pk-sr-only")
    refute_nil sr
    assert sr.ancestors.none? { |a| a.element? && a.has_attribute?("aria-hidden") }
  end

  def test_ellipsis_icons_stay_hidden_from_at
    [ PhlexKit::BreadcrumbEllipsis.new, PhlexKit::PaginationEllipsis.new ].each do |c|
      svg = Nokogiri::HTML5.fragment(render(c)).at_css("svg")
      assert_equal "true", svg["aria-hidden"]
    end
  end

  # --- Finding 7: role="separator" + aria-hidden="true" is contradictory —
  # these are decorative, so drop the role and keep aria-hidden.
  def test_button_group_separator_is_decorative_without_separator_role
    html = render(PhlexKit::ButtonGroupSeparator.new)
    refute_includes html, %(role="separator")
    # Phlex renders `aria: { hidden: true }` as a bare attribute.
    assert Nokogiri::HTML5.fragment(html).at_css("div").has_attribute?("aria-hidden")
  end

  def test_item_separator_is_decorative_without_separator_role
    html = render(PhlexKit::ItemSeparator.new)
    refute_includes html, %(role="separator")
    assert Nokogiri::HTML5.fragment(html).at_css("div").has_attribute?("aria-hidden")
  end

  # --- Finding 8: ItemGroup claimed role="list" but Items carry no
  # role="listitem" (and an href Item is an <a>, which must keep its link
  # role) — AT announced an empty list. Drop the list role.
  def test_item_group_does_not_claim_list_role
    html = render(PhlexKit::ItemGroup.new { "x" })
    assert_includes html, "pk-item-group"
    refute_includes html, %(role="list")
  end

  # --- Finding 9 (companion): basic Table render coverage.
  def test_table_renders_wrapper_and_mixes_caller_attrs_onto_table
    html = render(PhlexKit::Table.new(class: "extra", id: "users", data: { foo: "bar" }))
    doc = Nokogiri::HTML5.fragment(html)
    assert doc.at_css("div.pk-table-wrapper > table.pk-table")
    table = doc.at_css("table")
    assert_includes table["class"], "extra"
    assert_equal "users", table["id"]
    assert_equal "bar", table["data-foo"]
  end

  # --- Finding 10: the scrollable code block must be keyboard-focusable
  # (WCAG scrollable-region-focusable) and announce as a region.
  def test_codeblock_scroll_container_is_focusable_region
    html = render(PhlexKit::Codeblock.new("puts 1"))
    doc = Nokogiri::HTML5.fragment(html)
    block = doc.at_css(".pk-codeblock")
    assert_equal "0", block["tabindex"]
    assert_equal "region", block["role"]
  end

  def test_codeblock_caller_can_label_the_region
    html = render(PhlexKit::Codeblock.new("puts 1", aria: { label: "Example" }))
    assert_includes html, %(aria-label="Example")
  end

  # --- Finding 12 (companion): basic Checkbox render coverage.
  def test_checkbox_renders_native_input_with_form_field_wiring
    html = render(PhlexKit::Checkbox.new(name: "ok", class: "extra"))
    doc = Nokogiri::HTML5.fragment(html)
    input = doc.at_css("input")
    assert_equal "checkbox", input["type"]
    assert_includes input["class"], "pk-checkbox"
    assert_includes input["class"], "extra"
    assert_equal "ok", input["name"]
    assert_equal "input", input["data-phlex-kit--form-field-target"]
    assert_includes input["data-action"], "phlex-kit--form-field#onInput"
  end

  # --- Finding 13: Link render coverage.
  def test_link_default_variant_and_href
    html = render(PhlexKit::Link.new(href: "/docs") { "Docs" })
    assert_includes html, %(href="/docs")
    assert_includes html, "pk-button"
    assert_includes html, "link"
  end

  def test_link_button_variant_class
    html = render(PhlexKit::Link.new(href: "/x", variant: :outline, size: :sm) { "x" })
    link = Nokogiri::HTML5.fragment(html).at_css("a")
    assert_includes link["class"].split, "outline"
    assert_includes link["class"].split, "sm"
  end

  def test_link_unknown_variant_fails_loud
    assert_raises(KeyError) { render(PhlexKit::Link.new(variant: :nope) { "x" }) }
  end

  # --- Finding 14 (revised by audit round 5): the focus stop keeps its
  # unconditional tabindex, but role=region is now conditional on an
  # accessible name — a NAMELESS region is itself AT noise, so an unlabelled
  # ScrollArea omits the role while a labelled one announces as a region.
  def test_scroll_area_focus_stop_announces_as_region_only_when_named
    html = render(PhlexKit::ScrollArea.new { "x" })
    doc = Nokogiri::HTML5.fragment(html)
    area = doc.at_css(".pk-scroll-area")
    assert_equal "0", area["tabindex"]
    assert_nil area["role"]

    named = Nokogiri::HTML5.fragment(render(PhlexKit::ScrollArea.new(aria: { label: "Tags" }) { "x" })).at_css(".pk-scroll-area")
    assert_equal "0", named["tabindex"]
    assert_equal "region", named["role"]
  end
end
