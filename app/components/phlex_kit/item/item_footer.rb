module PhlexKit
  # Full-width footer band of an Item. Ported from shadcn/ui's ItemFooter.
  # See item.rb.
  class ItemFooter < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-item-footer" }, @attrs), &)
  end
end
