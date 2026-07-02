module PhlexKit
  # A <tr> in a PhlexKit::Table — bottom border + hover highlight. See table.rb.
  class TableRow < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      tr(**mix({ class: "pk-table-row" }, @attrs), &block)
    end
  end
end
