module PhlexKit
  # The element a PhlexKit::Tooltip is anchored to. `tabindex: 0` so keyboard users can
  # focus it (the bubble shows on `:focus-within`). See tooltip.rb.
  class TooltipTrigger < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      span(**mix({ class: "pk-tooltip-trigger", tabindex: 0 }, @attrs), &block)
    end
  end
end
