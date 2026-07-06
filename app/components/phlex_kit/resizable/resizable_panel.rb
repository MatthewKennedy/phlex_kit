module PhlexKit
  # One pane of a ResizablePanelGroup. `default_size:` is a percentage.
  # See resizable_panel_group.rb.
  class ResizablePanel < BaseComponent
    def initialize(default_size: nil, **attrs)
      # Numeric coercion: the value is interpolated into a style attribute, and
      # hosts plausibly round-trip saved panel sizes from client state.
      @default_size = default_size.nil? ? nil : Float(default_size)
      @attrs = attrs
    end

    def view_template(&)
      style = @default_size ? "flex-grow: #{Kernel.format("%g", @default_size)}" : nil
      div(**mix({
        class: "pk-resizable-panel",
        style: style,
        data: { phlex_kit__resizable_target: "panel" }
      }.compact, @attrs), &)
    end
  end
end
