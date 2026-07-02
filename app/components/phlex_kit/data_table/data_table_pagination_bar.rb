module PhlexKit
  # Footer row holding the selection summary, per-page select and pagination.
  # See data_table.rb.
  class DataTablePaginationBar < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({ class: "pk-data-table-pagination-bar" }, @attrs), &)
    end
  end
end
