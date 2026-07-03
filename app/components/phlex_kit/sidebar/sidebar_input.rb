module PhlexKit
  # Search/filter input for the sidebar, ported from shadcn/ui's SidebarInput:
  # the kit Input on the page background, sized to the sidebar's control height.
  # See sidebar.rb.
  class SidebarInput < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      render Input.new(**mix({ class: "pk-sidebar-input" }, @attrs))
    end
  end
end
