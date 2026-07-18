module PhlexKit
  # Header checkbox selecting every DataTableRowCheckbox on the page (the
  # controller sets indeterminate for partial selections). See data_table.rb.
  class DataTableSelectAllCheckbox < BaseComponent
    def initialize(label: "Select all", **attrs)
      @label = label
      @attrs = attrs
    end

    def view_template
      base = {
        data: {
          phlex_kit__data_table_target: "selectAll",
          action: "change->phlex-kit--data-table#toggleAll"
        }
      }
      # label: kwarg (mirrors DataTableRowCheckbox); default only when the
      # caller didn't supply their own accessible name — `mix` fuses.
      base[:aria] = { label: @label } unless aria_labelled?
      render Checkbox.new(**mix(base, @attrs))
    end
  end
end
