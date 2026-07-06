module PhlexKit
  # "N of M row(s) selected." line, kept current by the controller.
  # See data_table.rb.
  class DataTableSelectionSummary < BaseComponent
    def initialize(total_on_page: 0, **attrs)
      @total_on_page = total_on_page
      @attrs = attrs
    end

    def view_template
      div(**mix({
        class: "pk-data-table-selection-summary",
        role: "status", # live region — selection changes are announced to AT
        data: { phlex_kit__data_table_target: "selectionSummary" }
      }, @attrs)) do
        plain "0 of #{@total_on_page} row(s) selected."
      end
    end
  end
end
