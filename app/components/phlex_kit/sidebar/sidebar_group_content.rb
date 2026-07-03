module PhlexKit
  # Content container within a SidebarGroup, ported from shadcn/ui's
  # SidebarGroupContent. See sidebar.rb.
  class SidebarGroupContent < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({ class: "pk-sidebar-group-content" }, @attrs), &block)
    end
  end
end
