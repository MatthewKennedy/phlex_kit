module PhlexKit
  # Secondary action pinned to the right edge of a SidebarMenuItem (the item is
  # position:relative), ported from shadcn/ui's SidebarMenuAction. See sidebar.rb.
  class SidebarMenuAction < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      button(**mix({ class: "pk-sidebar-menu-action", type: :button }, @attrs), &block)
    end
  end
end
