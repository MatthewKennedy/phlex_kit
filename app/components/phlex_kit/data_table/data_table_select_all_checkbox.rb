module PhlexKit
  # Header checkbox selecting every DataTableRowCheckbox on the page (the
  # controller sets indeterminate for partial selections). See data_table.rb.
  class DataTableSelectAllCheckbox < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      render Checkbox.new(**mix({
        aria: { label: "Select all" },
        data: {
          phlex_kit__data_table_target: "selectAll",
          action: "change->phlex-kit--data-table#toggleAll"
        }
      }, @attrs))
    end
  end
end
