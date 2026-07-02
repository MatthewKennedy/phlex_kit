module PhlexKit
  # The tooltip bubble, revealed on hover/focus of its PhlexKit::Tooltip. See tooltip.rb.
  class TooltipContent < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({ class: "pk-tooltip-content", role: "tooltip" }, @attrs), &block)
    end
  end
end
