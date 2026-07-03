module PhlexKit
  # The interactive element of a SidebarMenuSubItem, ported from shadcn/ui's
  # SidebarMenuSubButton. `as:` is :a (their default — pass `href:`) or :button;
  # `active: true` highlights with the accent role (shadcn subs use accent, not
  # primary). Kwarg rather than attr for the same mix-merge reason as
  # SidebarMenuButton. See sidebar.rb.
  class SidebarMenuSubButton < BaseComponent
    def initialize(as: :a, active: false, **attrs)
      @as = as
      @active = active
      @attrs = attrs
    end

    def view_template(&block)
      send(@as, **mix({ class: "pk-sidebar-menu-sub-button", "data-active": (@active ? "true" : "false") }, @attrs), &block)
    end
  end
end
