module PhlexKit
  # Muted body copy of a PopoverHeader, ported from shadcn/ui's
  # PopoverDescription. See popover.rb.
  class PopoverDescription < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      p(**mix({ class: "pk-popover-description" }, @attrs), &)
    end
  end
end
