module PhlexKit
  # The hamburger that toggles an offcanvas sidebar, ported from shadcn/ui's
  # SidebarTrigger. Place it anywhere inside a
  # SidebarWrapper(collapsible: :offcanvas) — typically at the top of the
  # SidebarInset. Renders the :menu icon unless a block supplies its own
  # content. Hidden by CSS unless the wrapper is offcanvas. See sidebar.rb.
  class SidebarTrigger < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      button(**mix({
        type: :button,
        class: "pk-sidebar-trigger",
        aria_label: "Toggle sidebar",
        data: { action: "click->phlex-kit--sidebar#toggle" }
      }, @attrs)) do
        block ? yield : render(Icon.new(:menu, size: nil))
      end
    end
  end
end
