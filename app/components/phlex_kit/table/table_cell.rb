module PhlexKit
  # A body cell (<td>) in a PhlexKit::TableRow. See table.rb.
  class TableCell < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      td(**mix({ class: "pk-table-cell" }, @attrs), &block)
    end
  end
end
