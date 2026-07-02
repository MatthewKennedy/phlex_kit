module PhlexKit
  # The <caption> of a PhlexKit::Table (muted, below the table). See table.rb.
  class TableCaption < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      caption(**mix({ class: "pk-table-caption" }, @attrs), &block)
    end
  end
end
