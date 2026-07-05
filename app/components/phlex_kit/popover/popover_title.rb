module PhlexKit
  # Heading of a PopoverHeader, ported from shadcn/ui's PopoverTitle.
  # See popover.rb.
  class PopoverTitle < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      h2(**mix({ class: "pk-popover-title" }, @attrs), &)
    end
  end
end
