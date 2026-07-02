module PhlexKit
  # Per-row selection checkbox (a PhlexKit::Checkbox submitting `ids[]`).
  # See data_table.rb.
  class DataTableRowCheckbox < BaseComponent
    def initialize(value:, name: "ids[]", label: nil, **attrs)
      @value = value
      @name = name
      @label = label
      @attrs = attrs
    end

    def view_template
      render Checkbox.new(**mix({
        name: @name,
        value: @value,
        aria: { label: @label || "Select row #{@value}" },
        data: {
          phlex_kit__data_table_target: "rowCheckbox",
          action: "change->phlex-kit--data-table#toggleRow"
        }
      }, @attrs))
    end
  end
end
