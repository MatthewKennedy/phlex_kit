module PhlexKit
  # Drag handle between two ResizablePanels. `with_handle: true` shows the
  # visible grip pill (their withHandle). See resizable_panel_group.rb.
  class ResizableHandle < BaseComponent
    def initialize(with_handle: false, **attrs)
      @with_handle = with_handle
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
      }, @attrs)) do
        span(class: "pk-resizable-handle-grip", aria: { hidden: "true" }) if @with_handle
      end
    end
  end
end
