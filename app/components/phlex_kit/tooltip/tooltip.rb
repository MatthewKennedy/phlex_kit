module PhlexKit
  # Hover/focus tooltip. ruby_ui's version uses @floating-ui + a cloned template;
  # we keep the Trigger/Content structure but reveal + position the bubble with
  # pure CSS (no JS, no npm dep) — same call as the Select floating-ui strip.
  # The tiny phlex-kit--tooltip controller only wires aria-describedby and
  # Escape-dismiss (WCAG 1.4.13); reveal stays CSS.
  # Bubble sits above the trigger. Compose TooltipTrigger + TooltipContent.
  class Tooltip < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({ class: "pk-tooltip", data: { controller: "phlex-kit--tooltip" } }, @attrs), &block)
    end
  end
end
