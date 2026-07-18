module PhlexKit
  # Hairline between Items in an ItemGroup, ported from shadcn/ui's
  # ItemSeparator. See item.rb.
  class ItemSeparator < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template
      # Purely decorative — aria-hidden only (role="separator" would
      # contradict aria-hidden and confuse AT).
      div(**mix({ class: "pk-item-separator", aria: { hidden: "true" } }, @attrs))
    end
  end
end
