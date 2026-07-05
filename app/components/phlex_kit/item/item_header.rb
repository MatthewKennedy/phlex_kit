module PhlexKit
  # Full-width header band of an Item (e.g. a cover image) — the item stacks
  # into a column when present. Ported from shadcn/ui's ItemHeader. See item.rb.
  class ItemHeader < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-item-header" }, @attrs), &)
  end
end
