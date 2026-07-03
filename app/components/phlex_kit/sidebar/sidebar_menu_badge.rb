module PhlexKit
  # Non-interactive count/status pinned to the right edge of a SidebarMenuItem,
  # ported from shadcn/ui's SidebarMenuBadge. See sidebar.rb.
  class SidebarMenuBadge < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      span(**mix({ class: "pk-sidebar-menu-badge" }, @attrs), &block)
    end
  end
end
