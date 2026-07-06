# frozen_string_literal: true

require "test_helper"

# Round-2 audit fixes: AT announcements, input hardening, wiring cleanups.
class AuditRound2Test < Minitest::Test
  include RenderHelper

  def test_sort_head_announces_aria_sort
    sorted = render(PhlexKit::DataTableSortHead.new(column_key: :name, label: "Name", sort: "name", direction: "asc"))
    assert_includes sorted, %(aria-sort="ascending")

    desc = render(PhlexKit::DataTableSortHead.new(column_key: :name, label: "Name", sort: "name", direction: "desc"))
    assert_includes desc, %(aria-sort="descending")

    unsorted = render(PhlexKit::DataTableSortHead.new(column_key: :name, label: "Name"))
    refute_includes unsorted, "aria-sort"
  end

  def test_pagination_prev_next_have_accessible_names
    html = render(PhlexKit::DataTablePagination.new(page: 2, per_page: 10, total_count: 100))
    assert_includes html, %(aria-label="Go to previous page")
    assert_includes html, %(aria-label="Go to next page")
  end

  def test_pagination_disabled_edge_is_announced
    html = render(PhlexKit::DataTablePagination.new(page: 1, per_page: 10, total_count: 100))
    assert_match(/<span[^>]+aria-disabled="true"/, html)
  end

  def test_resizable_panel_coerces_default_size_numerically
    html = render(PhlexKit::ResizablePanel.new(default_size: "33.5") { "x" })
    assert_includes html, %(style="flex-grow: 33.5")
    assert_raises(ArgumentError) do
      PhlexKit::ResizablePanel.new(default_size: "1;position:fixed;inset:0")
    end
  end

  def test_selection_summary_is_a_live_status_region
    html = render(PhlexKit::DataTableSelectionSummary.new(total_on_page: 5))
    assert_includes html, %(role="status")
  end
end
