# frozen_string_literal: true

require "test_helper"

# DataTable — turbo-frame table with sort/search/selection, ported from ruby_ui.
class DataTableTest < Minitest::Test
  include RenderHelper

  def test_data_table_renders_frame_and_controller
    html = render(PhlexKit::DataTable.new(id: "reviews") { "x" })
    assert_includes html, %(<turbo-frame id="reviews" target="_top">)
    assert_includes html, "pk-data-table"
    assert_includes html, %(data-controller="phlex-kit--data-table")
  end

  def test_search_form_debounces_into_frame
    html = render(PhlexKit::DataTableSearch.new(path: "/reviews", value: "q", frame_id: "reviews", preserved_params: { "state" => "open", "empty" => "" }))
    assert_includes html, %(action="/reviews")
    assert_includes html, %(data-turbo-frame="reviews")
    assert_includes html, "input->phlex-kit--data-table-search#submit"
    assert_includes html, %(data-phlex-kit--data-table-search-delay-value="300")
    assert_includes html, %(name="state")
    refute_includes html, %(name="empty")
  end

  def test_search_without_debounce_has_no_controller
    refute_includes render(PhlexKit::DataTableSearch.new(path: "/r", debounce: 0)), "phlex-kit--data-table-search"
  end

  def test_column_toggle_lists_columns
    html = render(PhlexKit::DataTableColumnToggle.new(columns: [ { key: :status, label: "Status" } ]))
    assert_includes html, "phlex-kit--data-table-column-visibility"
    assert_includes html, %(data-column-key="status")
    assert_includes html, "change->phlex-kit--data-table-column-visibility#toggle"
    assert_includes html, "Columns"
  end

  def test_sort_head_cycles_direction_and_preserves_query
    html = render(PhlexKit::DataTableSortHead.new(column_key: :name, label: "Name", path: "/r", query: { "state" => "open", "page" => "3" }))
    assert_includes html, "sort=name"
    assert_includes html, "direction=asc"
    assert_includes html, "state=open"
    refute_includes html, "page=3"
    desc = render(PhlexKit::DataTableSortHead.new(column_key: :name, label: "Name", sort: "name", direction: "asc", path: "/r"))
    assert_includes desc, "direction=desc"
    cleared = render(PhlexKit::DataTableSortHead.new(column_key: :name, label: "Name", sort: "name", direction: "desc", path: "/r"))
    refute_includes cleared, "direction="
  end

  def test_selection_parts_wire_the_controller
    row = render(PhlexKit::DataTableRowCheckbox.new(value: 7))
    assert_includes row, %(data-phlex-kit--data-table-target="rowCheckbox")
    assert_includes row, %(aria-label="Select row 7")
    all = render(PhlexKit::DataTableSelectAllCheckbox.new)
    assert_includes all, "change->phlex-kit--data-table#toggleAll"
    assert_includes render(PhlexKit::DataTableBulkActions.new { "x" }), "pk-data-table-bulk-actions pk-hidden"
    assert_includes render(PhlexKit::DataTableSelectionSummary.new(total_on_page: 5)), "0 of 5 row(s) selected."
  end

  def test_expand_toggle_controls_a_row_detail
    html = render(PhlexKit::DataTableExpandToggle.new(controls: "row-7-detail"))
    assert_includes html, %(aria-controls="row-7-detail")
    assert_includes html, "click->phlex-kit--data-table#toggleRowDetail"
  end

  def test_form_includes_csrf_placeholder_outside_rails
    html = render(PhlexKit::DataTableForm.new(action: "/bulk") { "x" })
    assert_includes html, %(name="authenticity_token")
  end

  def test_pagination_windows_pages_and_disables_edges
    html = render(PhlexKit::DataTablePagination.new(page: 5, per_page: 10, total_count: 200, path: "/r"))
    assert_includes html, "pk-pagination"
    assert_includes html, "page=4"
    assert_includes html, "page=6"
    assert_includes html, "pk-pagination-ellipsis"
    single = render(PhlexKit::DataTablePagination.new(page: 1, per_page: 10, total_count: 5, path: "/r"))
    assert_equal "", single
  end

  def test_pagination_requires_an_adapter
    assert_raises(ArgumentError) { PhlexKit::DataTablePagination.new }
  end

  def test_per_page_select_self_submits
    html = render(PhlexKit::DataTablePerPageSelect.new(path: "/r", value: 25, frame_id: "reviews"))
    assert_includes html, "this.form.requestSubmit()"
    assert_includes html, %(<option value="25" selected)
    assert_includes html, %(data-turbo-frame="reviews")
  end
end
