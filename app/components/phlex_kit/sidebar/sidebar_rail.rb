module PhlexKit
  # Invisible grab strip along the sidebar's trailing edge — clicking it
  # toggles the collapse, like shadcn/ui's SidebarRail. Place it as the last
  # child of a Sidebar inside a collapsible wrapper. See sidebar.rb.
  class SidebarRail < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      button(**mix({
        type: :button,
        class: "pk-sidebar-rail",
        aria_label: "Toggle sidebar",
        tabindex: "-1",
        title: "Toggle sidebar",
        data: { action: "click->phlex-kit--sidebar#toggle" }
      }, @attrs))
    end
  end
end
