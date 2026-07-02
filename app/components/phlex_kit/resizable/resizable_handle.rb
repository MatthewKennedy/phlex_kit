module PhlexKit
  # Drag handle between two ResizablePanels. See resizable_panel_group.rb.
  class ResizableHandle < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      div(**mix({
        class: "pk-resizable-handle",
        role: "separator",
        tabindex: "0",
        aria: { orientation: "vertical" },
        data: {
          phlex_kit__resizable_target: "handle",
          action: "pointerdown->phlex-kit--resizable#start"
        }
      }, @attrs))
    end
  end
end
