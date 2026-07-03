module PhlexKit
  # Nested submenu list under a SidebarMenuItem, ported from shadcn/ui's
  # SidebarMenuSub. See sidebar.rb.
  class SidebarMenuSub < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      ul(**mix({ class: "pk-sidebar-menu-sub" }, @attrs), &block)
    end
  end
end
