module PhlexKit
  # The <tbody> of a PhlexKit::Table. See table.rb.
  class TableBody < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      tbody(**mix({ class: "pk-table-body" }, @attrs), &block)
    end
  end
end
