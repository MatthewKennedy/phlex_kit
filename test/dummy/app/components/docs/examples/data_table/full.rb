# frozen_string_literal: true

module Docs
  module Examples
    module DataTable
      class Full < Phlex::HTML
        # Their tutorial's payments dataset, end-state columns and all.
        PAYMENTS = [
          [ "m5gr84i9", "ken99@example.com", "Success", "$316.00" ],
          [ "3u1reuv4", "Abe45@example.com", "Success", "$242.00" ],
          [ "derv1ws0", "Monserrat44@example.com", "Processing", "$837.00" ],
          [ "5kma53ae", "Silas22@example.com", "Success", "$874.00" ],
          [ "bhqecj4p", "carmella@example.com", "Failed", "$721.00" ]
        ].freeze

        def view_template
          # The shadcn page builds this up step by step (columns → sorting →
          # filtering → visibility → pagination → row selection). The kit's
          # DataTable is server-driven — sorting/filtering/pagination are
          # links and params your controller answers inside the turbo-frame —
          # so the steps below are markup, not column defs.
          render PhlexKit::DataTable.new(id: "payments") do
            # Step: filtering — a debounced input that reloads the frame.
            render PhlexKit::DataTableToolbar.new do
              render PhlexKit::DataTableSearch.new(path: "/docs/data-table", frame_id: "payments", placeholder: "Filter emails...")
              # Kit extra: bulk actions appear once rows are selected.
              render PhlexKit::DataTableBulkActions.new do
                render PhlexKit::Button.new(variant: :destructive, size: :sm) { "Delete selected" }
              end
              # Step: column visibility — toggles cells carrying data-column.
              render PhlexKit::DataTableColumnToggle.new(columns: [ { key: "status", label: "Status" }, { key: "amount", label: "Amount" } ])
            end
            render PhlexKit::Table.new do
              render PhlexKit::TableHeader.new do
                render PhlexKit::TableRow.new do
                  # Step: row selection — header checkbox drives the rows.
                  render PhlexKit::TableHead.new { render PhlexKit::DataTableSelectAllCheckbox.new }
                  render PhlexKit::TableHead.new(data: { column: "status" }) { "Status" }
                  # Step: sorting — a link cycling asc → desc → unsorted.
                  render PhlexKit::DataTableSortHead.new(column_key: :email, label: "Email", path: "/docs/data-table")
                  render PhlexKit::TableHead.new(data: { column: "amount" }, style: "text-align: right") { "Amount" }
                  render PhlexKit::TableHead.new(style: "width: 2rem") { span(class: "pk-sr-only") { "Actions" } }
                end
              end
              render PhlexKit::TableBody.new do
                PAYMENTS.each do |id, email, status, amount|
                  render PhlexKit::TableRow.new do
                    render PhlexKit::TableCell.new { render PhlexKit::DataTableRowCheckbox.new(value: id) }
                    render PhlexKit::TableCell.new(data: { column: "status" }) { status }
                    render PhlexKit::TableCell.new(style: "font-weight: 500") { email }
                    render PhlexKit::TableCell.new(data: { column: "amount" }, style: "text-align: right; font-variant-numeric: tabular-nums;") { amount }
                    # Step: row actions — a per-row dropdown menu.
                    render PhlexKit::TableCell.new do
                      render PhlexKit::DropdownMenu.new do
                        render PhlexKit::DropdownMenuTrigger.new do
                          render PhlexKit::Button.new(variant: :ghost, icon: true, aria: { label: "Open menu for #{id}" }) do
                            render PhlexKit::Icon.new(:ellipsis, size: nil)
                          end
                        end
                        render PhlexKit::DropdownMenuContent.new(style: "left: auto; right: 0") do
                          render PhlexKit::DropdownMenuLabel.new { "Actions" }
                          render PhlexKit::DropdownMenuItem.new(href: "#") { "Copy payment ID" }
                          render PhlexKit::DropdownMenuSeparator.new
                          render PhlexKit::DropdownMenuItem.new(href: "#") { "View customer" }
                          render PhlexKit::DropdownMenuItem.new(href: "#") { "View payment details" }
                        end
                      end
                    end
                  end
                end
              end
            end
            # Step: pagination — server-driven links + the selection summary.
            render PhlexKit::DataTablePaginationBar.new do
              render PhlexKit::DataTableSelectionSummary.new(total_on_page: PAYMENTS.size)
              render PhlexKit::DataTablePagination.new(page: 1, per_page: 5, total_count: 20, path: "/docs/data-table")
            end
          end
        end
      end
    end
  end
end
