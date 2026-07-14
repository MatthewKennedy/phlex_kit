module PhlexKit
  # The hamburger that toggles an offcanvas sidebar, ported from shadcn/ui's
  # SidebarTrigger. Place it anywhere inside a
  # SidebarWrapper(collapsible: :offcanvas) — typically at the top of the
  # SidebarInset. Renders the :menu icon unless a block supplies its own
  # content. Hidden by CSS unless the wrapper is offcanvas. `expanded:` renders
  # the initial aria-expanded (pass false when the wrapper starts
  # default_collapsed); the phlex-kit--sidebar controller keeps it in sync on
  # toggle. `controls:` renders aria-controls pointing at the Sidebar's id —
  # when omitted, the controller wires it on connect (generating an id on the
  # sidebar if needed). See sidebar.rb.
  class SidebarTrigger < BaseComponent
    def initialize(expanded: true, controls: nil, **attrs)
      @expanded = expanded
      @controls = controls
      @attrs = attrs
    end

    def view_template(&block)
      base = {
        type: :button,
        class: "pk-sidebar-trigger",
        aria_label: "Toggle sidebar",
        "aria-expanded": @expanded ? "true" : "false",
        data: { action: "click->phlex-kit--sidebar#toggle" }
      }
      base["aria-controls"] = @controls if @controls
      button(**mix(base, @attrs)) do
        block ? yield : render(Icon.new(:menu, size: nil))
      end
    end
  end
end
