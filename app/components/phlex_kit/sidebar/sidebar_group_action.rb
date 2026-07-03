module PhlexKit
  # Action button pinned to the top-right of a SidebarGroup (the group is the
  # positioning context), ported from shadcn/ui's SidebarGroupAction.
  # See sidebar.rb.
  class SidebarGroupAction < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      button(**mix({ class: "pk-sidebar-group-action", type: "button" }, @attrs), &block)
    end
  end
end
