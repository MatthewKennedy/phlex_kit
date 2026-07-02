module PhlexKit
  # Top region of a PhlexKit::Sidebar (brand + store switcher). See sidebar.rb.
  class SidebarHeader < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({ class: "pk-sidebar-header" }, @attrs), &block)
    end
  end
end
