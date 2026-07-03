module PhlexKit
  # Divider between sidebar sections, ported from shadcn/ui's SidebarSeparator:
  # the kit Separator inset to the sidebar's padding and tinted with the
  # sidebar border role. See sidebar.rb.
  class SidebarSeparator < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      render Separator.new(**mix({ class: "pk-sidebar-separator" }, @attrs))
    end
  end
end
