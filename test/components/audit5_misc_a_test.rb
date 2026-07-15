# frozen_string_literal: true

require "test_helper"
require "nokogiri"

# Audit round 5 — misc cluster A: collapsible trigger aria placement and
# ScrollArea's conditional region role.
class Audit5MiscATest < Minitest::Test
  include RenderHelper

  # --- collapsible ---

  # The wrapper still carries the server-rendered aria-expanded (the
  # component can't reach into its block pre-JS); the controller relocates
  # it onto the nested focusable control on connect — covered by the
  # audit5 system test.
  def test_collapsible_trigger_wrapper_carries_pre_js_aria_expanded
    closed = render(PhlexKit::CollapsibleTrigger.new { "Toggle" })
    doc = Nokogiri::HTML5.fragment(closed)
    wrapper = doc.at_css(".pk-collapsible-trigger")
    assert_equal "false", wrapper["aria-expanded"]
    assert_equal "trigger", wrapper["data-phlex-kit--collapsible-target"]
    assert_includes wrapper["data-action"], "phlex-kit--collapsible#toggle"

    open = render(PhlexKit::CollapsibleTrigger.new(open: true) { "Toggle" })
    assert_equal "true", Nokogiri::HTML5.fragment(open).at_css(".pk-collapsible-trigger")["aria-expanded"]
  end

  # aria-controls is wired by the controller at connect (the trigger can't
  # know the content's id at render time) — the server must NOT emit one.
  def test_collapsible_trigger_renders_no_aria_controls_server_side
    html = render(PhlexKit::CollapsibleTrigger.new { "Toggle" })
    refute_includes html, "aria-controls"
  end

  # --- scroll_area ---

  def test_scroll_area_without_a_name_stays_focusable_but_has_no_role
    doc = Nokogiri::HTML5.fragment(render(PhlexKit::ScrollArea.new { "x" }))
    area = doc.at_css(".pk-scroll-area")
    assert_equal "0", area["tabindex"]
    assert_nil area["role"]
  end

  def test_scroll_area_with_aria_label_hash_announces_as_region
    doc = Nokogiri::HTML5.fragment(render(PhlexKit::ScrollArea.new(aria: { label: "Tags" }) { "x" }))
    area = doc.at_css(".pk-scroll-area")
    assert_equal "region", area["role"]
    assert_equal "Tags", area["aria-label"]
    assert_equal "0", area["tabindex"]
  end

  def test_scroll_area_with_flat_aria_label_attr_announces_as_region
    doc = Nokogiri::HTML5.fragment(render(PhlexKit::ScrollArea.new(aria_label: "Tags") { "x" }))
    assert_equal "region", doc.at_css(".pk-scroll-area")["role"]
  end

  def test_scroll_area_with_aria_labelledby_announces_as_region
    doc = Nokogiri::HTML5.fragment(render(PhlexKit::ScrollArea.new(aria: { labelledby: "tags-h" }) { "x" }))
    assert_equal "region", doc.at_css(".pk-scroll-area")["role"]
  end
end
