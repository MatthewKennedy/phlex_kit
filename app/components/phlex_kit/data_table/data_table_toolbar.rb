module PhlexKit
  # Row above the table for search / bulk actions / column toggle.
  # See data_table.rb.
  class DataTableToolbar < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({ class: "pk-data-table-toolbar" }, @attrs), &)
    end
  end
end
