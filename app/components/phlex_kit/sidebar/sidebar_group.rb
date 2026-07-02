module PhlexKit
  # A cluster of menu items within SidebarContent. See sidebar.rb.
  class SidebarGroup < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({ class: "pk-sidebar-group" }, @attrs), &block)
    end
  end
end
