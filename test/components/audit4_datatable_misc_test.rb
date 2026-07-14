# frozen_string_literal: true

require "test_helper"

# Audit round 4 — data_table misc, attachment, bubble fixes.
class Audit4DatatableMiscTest < Minitest::Test
  include RenderHelper

  # Pagy 9 renamed #items to #limit — the adapter must work with both.
  LimitPagy = Struct.new(:page, :pages, :count, :limit)
  ItemsPagy = Struct.new(:page, :pages, :count, :items)

  def test_pagy_adapter_reads_limit_on_current_pagy
    adapter = PhlexKit::DataTablePagyAdapter.new(LimitPagy.new(2, 10, 100, 25))
    assert_equal 25, adapter.per_page
  end

  def test_pagy_adapter_still_reads_items_on_legacy_pagy
    adapter = PhlexKit::DataTablePagyAdapter.new(ItemsPagy.new(2, 10, 100, 10))
    assert_equal 10, adapter.per_page
  end

  def test_per_page_select_preserves_params_as_hidden_fields
    html = render(PhlexKit::DataTablePerPageSelect.new(
      path: "/r", name: "per_page",
      preserved_params: { "search" => "q", "sort" => "name", "empty" => "", "nil" => nil, "per_page" => "999" }
    ))
    assert_includes html, %(<input type="hidden" name="search" value="q">)
    assert_includes html, %(<input type="hidden" name="sort" value="name">)
    refute_includes html, %(name="empty")
    refute_includes html, %(name="nil")
    # Its own param must not be duplicated by a hidden field.
    refute_includes html, %(<input type="hidden" name="per_page")
  end

  def test_per_page_select_submits_via_stimulus_not_inline_js
    html = render(PhlexKit::DataTablePerPageSelect.new(path: "/r", value: 25, frame_id: "reviews"))
    refute_includes html, "this.form.requestSubmit()"
    refute_includes html, "onchange"
    assert_includes html, %(data-controller="phlex-kit--data-table-search")
    assert_includes html, "change->phlex-kit--data-table-search#submitNow"
  end

  def test_column_toggle_rows_are_menuitemcheckboxes
    html = render(PhlexKit::DataTableColumnToggle.new(columns: [ { key: :status, label: "Status" } ]))
    assert_includes html, %(role="menuitemcheckbox")
    assert_includes html, %(aria-checked="true")
    # Column-visibility wiring survives the new row markup.
    assert_includes html, %(data-column-key="status")
    assert_includes html, "change->phlex-kit--data-table-column-visibility#toggle"
    # No bare label rows directly inside the menu anymore.
    refute_includes html, %(<label class="pk-data-table-column-option">)
  end

  def test_attachment_trigger_renders_its_block
    html = render(PhlexKit::AttachmentTrigger.new(aria: { label: "Open" }) { "peek" })
    assert_includes html, "peek"
    linked = render(PhlexKit::AttachmentTrigger.new(as: :a, href: "/f.pdf", aria: { label: "Open" }) { "open file" })
    assert_includes linked, "open file"
  end

  def test_attachment_action_has_a_default_accessible_name
    html = render(PhlexKit::AttachmentAction.new)
    assert_includes html, %(<span class="pk-sr-only">Remove</span>)
    custom = render(PhlexKit::AttachmentAction.new(label: "Download"))
    assert_includes custom, %(<span class="pk-sr-only">Download</span>)
  end

  def test_bubble_content_whitelists_the_as_tag
    assert_includes render(PhlexKit::BubbleContent.new(as: :p) { "hi" }), "<p"
    assert_raises(ArgumentError) { render(PhlexKit::BubbleContent.new(as: :system) { "hi" }) }
  end

  def test_bubble_validates_align
    assert_includes render(PhlexKit::Bubble.new(align: :end) { "x" }), %(data-align="end")
    assert_raises(KeyError) { render(PhlexKit::Bubble.new(align: :sideways) { "x" }) }
  end

  def test_bubble_reactions_validate_side_and_align
    html = render(PhlexKit::BubbleReactions.new(side: :top, align: :start) { "x" })
    assert_includes html, %(data-side="top")
    assert_includes html, %(data-align="start")
    assert_raises(KeyError) { render(PhlexKit::BubbleReactions.new(side: :middle) { "x" }) }
    assert_raises(KeyError) { render(PhlexKit::BubbleReactions.new(align: :center) { "x" }) }
  end
end
