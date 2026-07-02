module PhlexKit
  # Action cluster revealed while rows are selected. See data_table.rb.
  class DataTableBulkActions < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({
        class: "pk-data-table-bulk-actions pk-hidden",
        data: { phlex_kit__data_table_target: "bulkActions" }
      }, @attrs), &)
    end
  end
end
