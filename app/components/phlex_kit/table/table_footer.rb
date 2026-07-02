module PhlexKit
  # The <tfoot> of a PhlexKit::Table (e.g. a totals row). See table.rb.
  class TableFooter < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      tfoot(**mix({ class: "pk-table-footer" }, @attrs), &block)
    end
  end
end
