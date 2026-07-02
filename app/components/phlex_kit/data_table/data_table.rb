module PhlexKit
  # Data table, ported from ruby_ui's RubyUI::DataTable: a server-driven
  # sortable/searchable table living in a <turbo-frame>, built on the kit's
  # Table / DropdownMenu / Input / Pagination parts. Row selection, bulk-action
  # visibility and row-detail expansion live in the phlex-kit--data-table
  # controller; search debounce and column visibility in their own controllers.
  # Compose DataTable(id:) > DataTableToolbar(DataTableSearch +
  # DataTableColumnToggle) + Table(DataTableSortHead, DataTableRowCheckbox …) +
  # DataTablePaginationBar(DataTableSelectionSummary + DataTablePerPageSelect +
  # DataTablePagination). Tailwind → vanilla `.pk-data-table*` (data_table.css).
  class DataTable < BaseComponent
    register_element :turbo_frame, tag: "turbo-frame"

    def initialize(id:, **attrs)
      @id = id
      @attrs = attrs
    end

    def view_template(&block)
      turbo_frame(id: @id, target: "_top") do
        div(**mix({ class: "pk-data-table", data: { controller: "phlex-kit--data-table" } }, @attrs), &block)
      end
    end
  end
end
