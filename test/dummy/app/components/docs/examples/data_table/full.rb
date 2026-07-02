# frozen_string_literal: true

module Docs
  module Examples
    module DataTable
      class Full < Phlex::HTML
        ROWS = [
          [ 1, "ken99@example.com", "Success", "$316.00" ],
          [ 2, "abe45@example.com", "Success", "$242.00" ],
          [ 3, "monserrat44@example.com", "Processing", "$837.00" ],
          [ 4, "carmella@example.com", "Failed", "$721.00" ]
        ].freeze

        def view_template
          render PhlexKit::DataTable.new(id: "payments") do
            render PhlexKit::DataTableToolbar.new do
              render PhlexKit::DataTableSearch.new(path: "/docs/data-table", frame_id: "payments", placeholder: "Filter emails…")
              render PhlexKit::DataTableBulkActions.new do
                render PhlexKit::Button.new(variant: :destructive, size: :sm) { "Delete selected" }
              end
              render PhlexKit::DataTableColumnToggle.new(columns: [ { key: "status", label: "Status" }, { key: "amount", label: "Amount" } ])
            end
            render PhlexKit::Table.new do
              render PhlexKit::TableHeader.new do
                render PhlexKit::TableRow.new do
                  render PhlexKit::TableHead.new { render PhlexKit::DataTableSelectAllCheckbox.new }
                  render PhlexKit::DataTableSortHead.new(column_key: :email, label: "Email", path: "/docs/data-table")
                  render PhlexKit::TableHead.new(data: { column: "status" }) { "Status" }
                  render PhlexKit::TableHead.new(data: { column: "amount" }) { "Amount" }
                end
              end
              render PhlexKit::TableBody.new do
                ROWS.each do |id, email, status, amount|
                  render PhlexKit::TableRow.new do
                    render PhlexKit::TableCell.new { render PhlexKit::DataTableRowCheckbox.new(value: id) }
                    render PhlexKit::TableCell.new { email }
                    render PhlexKit::TableCell.new(data: { column: "status" }) { status }
                    render PhlexKit::TableCell.new(data: { column: "amount" }) { amount }
                  end
                end
              end
            end
            render PhlexKit::DataTablePaginationBar.new do
              render PhlexKit::DataTableSelectionSummary.new(total_on_page: ROWS.size)
              render PhlexKit::DataTablePagination.new(page: 1, per_page: 10, total_count: 40, path: "/docs/data-table")
            end
          end
        end
      end
    end
  end
end
