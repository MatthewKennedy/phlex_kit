module PhlexKit
  # Heading for a SidebarGroup, ported from shadcn/ui's SidebarGroupLabel.
  # See sidebar.rb.
  class SidebarGroupLabel < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({ class: "pk-sidebar-group-label" }, @attrs), &block)
    end
  end
end
