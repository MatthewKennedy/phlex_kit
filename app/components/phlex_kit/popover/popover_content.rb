module PhlexKit
  class PopoverContent < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-popover-content pk-hidden", data: { phlex_kit__popover_target: "content", state: "closed" } }, @attrs), &)
    end
  end
end
