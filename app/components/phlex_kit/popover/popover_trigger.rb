module PhlexKit
  class PopoverTrigger < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-popover-trigger", data: { phlex_kit__popover_target: "trigger", action: "pointerdown->phlex-kit--popover#armToggle click->phlex-kit--popover#toggle" } }, @attrs), &)
    end
  end
end
