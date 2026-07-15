# frozen_string_literal: true

require "test_helper"
require "nokogiri"

# Audit round 5 regression tests: BubbleContent interactive as: tags,
# close-wrapper style-attr merging, Select value handling, and Tabs
# server-rendered active state.
class Audit5FixesTest < Minitest::Test
  include RenderHelper

  # --- Finding 1: BubbleContent's as: whitelist must keep the documented
  # interactive tags (button/a) — the audit-round-4 hardening dropped them,
  # 500ing /docs/bubble and orphaning bubble.css's button/a hover rules.
  def test_bubble_content_renders_as_button
    html = render(PhlexKit::BubbleContent.new(as: :button, type: "button") { "Hi" })
    node = Nokogiri::HTML5.fragment(html).at_css("button.pk-bubble-content")
    refute_nil node, "as: :button should render a <button class=pk-bubble-content>"
    assert_equal "button", node["type"]
  end

  def test_bubble_content_renders_as_anchor
    html = render(PhlexKit::BubbleContent.new(as: :a, href: "/x") { "Hi" })
    node = Nokogiri::HTML5.fragment(html).at_css("a.pk-bubble-content")
    refute_nil node, "as: :a should render an <a class=pk-bubble-content>"
    assert_equal "/x", node["href"]
  end

  def test_bubble_content_still_rejects_unknown_tags
    assert_raises(ArgumentError) { PhlexKit::BubbleContent.new(as: :script) }
  end

  # --- Finding 2: SheetClose/DialogClose inline style must end with ";" so a
  # caller style: merges into two valid declarations (Phlex joins duplicate
  # string attrs with a space).
  def test_sheet_close_style_merges_with_caller_style
    html = render(PhlexKit::SheetClose.new(style: "color: red;") { "X" })
    assert_includes html, %(style="display: contents; color: red;")
  end

  def test_dialog_close_style_merges_with_caller_style
    html = render(PhlexKit::DialogClose.new(style: "color: red;") { "X" })
    assert_includes html, %(style="display: contents; color: red;")
  end

  # --- Finding 5a: a value-less SelectItem used to submit the literal string
  # "undefined" (nil data attrs are omitted; the controller copied
  # item.dataset.value verbatim). Fail loud instead.
  def test_select_item_requires_a_value
    error = assert_raises(ArgumentError) { PhlexKit::SelectItem.new }
    assert_match(/value/i, error.message)
  end

  # --- Finding 5b: SelectContent generated its id inside the mix defaults, so
  # a caller id: fused into "pk-select-content-xxxx caller-id" (invalid id,
  # breaks aria-controls and generated item ids). The caller's id must win.
  def test_select_content_caller_id_wins_unfused
    html = render(PhlexKit::SelectContent.new(id: "my-listbox") { })
    node = Nokogiri::HTML5.fragment(html).at_css(".pk-select-content")
    assert_equal "my-listbox", node["id"]
  end

  def test_select_content_generates_id_when_caller_omits_it
    html = render(PhlexKit::SelectContent.new { })
    node = Nokogiri::HTML5.fragment(html).at_css(".pk-select-content")
    assert_match(/\Apk-select-content-\h{8}\z/, node["id"])
  end

  # --- Finding 5c: listbox options must activate on Space as well as Enter.
  def test_select_item_selects_on_space
    html = render(PhlexKit::SelectItem.new(value: "a") { "A" })
    assert_includes html, "keydown.space->phlex-kit--select#selectItem"
  end

  # --- Finding 8: a server-rendered active TabsTrigger must carry
  # data-state="active" — tabs.css styles the active trigger exclusively via
  # [data-state], so pre-hydration/no-JS the active tab looked inactive.
  def test_tabs_trigger_active_renders_data_state
    html = render(PhlexKit::TabsTrigger.new(value: "b", active: true) { "B" })
    node = Nokogiri::HTML5.fragment(html).at_css(".pk-tabs-trigger")
    assert_equal "active", node["data-state"]
    assert_equal "true", node["aria-selected"]
  end

  def test_tabs_trigger_inactive_renders_data_state_inactive
    html = render(PhlexKit::TabsTrigger.new(value: "b") { "B" })
    assert_equal "inactive", Nokogiri::HTML5.fragment(html).at_css(".pk-tabs-trigger")["data-state"]
  end
end
