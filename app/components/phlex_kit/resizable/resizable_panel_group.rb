module PhlexKit
  # Resizable split panels, ported from shadcn/ui's Resizable. The
  # react-resizable-panels dependency is replaced by the phlex-kit--resizable
  # controller: dragging a ResizableHandle rebalances the flex-grow of its
  # neighbouring ResizablePanels. Compose ResizablePanelGroup(direction:) >
  # ResizablePanel + ResizableHandle + ResizablePanel…
  # `.pk-resizable*` (resizable.css).
  class ResizablePanelGroup < BaseComponent
    DIRECTIONS = { horizontal: "horizontal", vertical: "vertical" }.freeze

    def initialize(direction: :horizontal, **attrs)
      @direction = DIRECTIONS.fetch(direction.to_sym)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({
        class: "pk-resizable-group #{@direction}",
        data: {
          controller: "phlex-kit--resizable",
          phlex_kit__resizable_direction_value: @direction
        }
      }, @attrs), &)
    end
  end
end
