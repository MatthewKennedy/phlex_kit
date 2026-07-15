module PhlexKit
  # One pane of a ResizablePanelGroup. `default_size:`, `min_size:` and
  # `max_size:` are percentages of the group (shadcn's defaultSize/minSize/
  # maxSize); the bounds ride along as data attributes the resizable
  # controller clamps drags and keyboard resizes against.
  # See resizable_panel_group.rb.
  class ResizablePanel < BaseComponent
    def initialize(default_size: nil, min_size: nil, max_size: nil, **attrs)
      # Numeric coercion: the values are interpolated into attributes, and
      # hosts plausibly round-trip saved panel sizes from client state.
      @default_size = default_size.nil? ? nil : Float(default_size)
      @min_size = min_size.nil? ? nil : Float(min_size)
      @max_size = max_size.nil? ? nil : Float(max_size)
      @attrs = attrs
    end

    def view_template(&)
      # Trailing ";" matters: Phlex's mix joins string attrs with a space, so
      # a caller style: would otherwise fuse into one invalid declaration.
      style = @default_size ? "flex-grow: #{Kernel.format("%g", @default_size)};" : nil
      div(**mix({
        class: "pk-resizable-panel",
        style: style,
        data: {
          phlex_kit__resizable_target: "panel",
          phlex_kit__resizable_min_size: @min_size && Kernel.format("%g", @min_size),
          phlex_kit__resizable_max_size: @max_size && Kernel.format("%g", @max_size)
        }.compact
      }.compact, @attrs), &)
    end
  end
end
