module PhlexKit
  # One pane of a ResizablePanelGroup. `default_size:` is a percentage.
  # See resizable_panel_group.rb.
  class ResizablePanel < BaseComponent
    def initialize(default_size: nil, **attrs)
      @default_size = default_size
      @attrs = attrs
    end

    def view_template(&)
      style = @default_size ? "flex-grow: #{@default_size}" : nil
      div(**mix({
        class: "pk-resizable-panel",
        style: style,
        data: { phlex_kit__resizable_target: "panel" }
      }.compact, @attrs), &)
    end
  end
end
