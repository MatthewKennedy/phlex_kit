module PhlexKit
  # "N of M row(s) selected." line, kept current by the controller.
  # `format:` localizes it — a template with %{selected} and %{total}
  # placeholders, used for the server render AND stamped on the element so
  # the controller's live updates interpolate the same string.
  # See data_table.rb.
  class DataTableSelectionSummary < BaseComponent
    DEFAULT_FORMAT = "%{selected} of %{total} row(s) selected."

    def initialize(total_on_page: 0, format: DEFAULT_FORMAT, **attrs)
      @total_on_page = total_on_page
      @format = format
      @attrs = attrs
    end

    def view_template
      div(**mix({
        class: "pk-data-table-selection-summary",
        role: "status", # live region — selection changes are announced to AT
        data: {
          phlex_kit__data_table_target: "selectionSummary",
          format: @format
        }
      }, @attrs)) do
        plain Kernel.format(@format, selected: 0, total: @total_on_page)
      end
    end
  end
end
