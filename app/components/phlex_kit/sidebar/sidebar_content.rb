module PhlexKit
  # Scrollable middle region of a PhlexKit::Sidebar (holds the nav menu). See sidebar.rb.
  class SidebarContent < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({ class: "pk-sidebar-content" }, @attrs), &block)
    end
  end
end
