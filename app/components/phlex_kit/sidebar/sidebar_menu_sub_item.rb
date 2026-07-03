module PhlexKit
  # An item within a SidebarMenuSub, ported from shadcn/ui's SidebarMenuSubItem.
  # See sidebar.rb.
  class SidebarMenuSubItem < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      li(**mix({ class: "pk-sidebar-menu-sub-item" }, @attrs), &block)
    end
  end
end
