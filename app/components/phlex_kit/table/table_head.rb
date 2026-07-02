module PhlexKit
  # A header cell (<th>) in a PhlexKit::TableHeader row. See table.rb.
  class TableHead < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      th(**mix({ class: "pk-table-head" }, @attrs), &block)
    end
  end
end
