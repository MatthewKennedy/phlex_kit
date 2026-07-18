module PhlexKit
  # Drag handle between two ResizablePanels. `with_handle: true` shows the
  # visible grip pill (their withHandle). See resizable_panel_group.rb.
  class ResizableHandle < BaseComponent
    def initialize(with_handle: false, **attrs)
      @with_handle = with_handle
      @attrs = attrs
    end

    def view_template
      base = {
        class: "pk-resizable-handle",
        data: {
          phlex_kit__resizable_target: "handle",
          action: "pointerdown->phlex-kit--resizable#start keydown->phlex-kit--resizable#keydown"
        }
      }
      # Defaults only when the caller didn't supply their own — `mix` fuses.
      base[:role] = "separator" unless attr_set?(:role)
      base[:tabindex] = "0" unless attr_set?(:tabindex)
      # Correct for the default horizontal group; the controller re-stamps
      # orientation (and aria-valuenow/min/max) per group direction on connect.
      base[:aria] = { orientation: "vertical" } unless aria_key_set?(:orientation)
      div(**mix(base, @attrs)) do
        span(class: "pk-resizable-handle-grip", aria: { hidden: "true" }) if @with_handle
      end
    end
  end
end
