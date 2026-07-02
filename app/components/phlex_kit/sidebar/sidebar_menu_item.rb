module PhlexKit
  # A single nav row (<li>) in a SidebarMenu. See sidebar.rb.
  class SidebarMenuItem < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      li(**mix({ class: "pk-sidebar-menu-item" }, @attrs), &block)
    end
  end
end
