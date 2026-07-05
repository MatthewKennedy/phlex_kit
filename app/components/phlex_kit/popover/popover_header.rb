module PhlexKit
  # Title + description block at the top of a PopoverContent, ported from
  # shadcn/ui's PopoverHeader. See popover.rb.
  class PopoverHeader < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-popover-header" }, @attrs), &)
    end
  end
end
