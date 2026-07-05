module PhlexKit
  # Hairline between Items in an ItemGroup, ported from shadcn/ui's
  # ItemSeparator. See item.rb.
  class ItemSeparator < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template
      div(**mix({ class: "pk-item-separator", role: "separator", aria: { hidden: true } }, @attrs))
    end
  end
end
