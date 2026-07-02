module PhlexKit
  # The nav list (<ul>) inside SidebarContent. See sidebar.rb.
  class SidebarMenu < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      ul(**mix({ class: "pk-sidebar-menu" }, @attrs), &block)
    end
  end
end
