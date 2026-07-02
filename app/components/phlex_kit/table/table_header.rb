module PhlexKit
  # The <thead> of a PhlexKit::Table. See table.rb.
  class TableHeader < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      thead(**mix({ class: "pk-table-header" }, @attrs), &block)
    end
  end
end
