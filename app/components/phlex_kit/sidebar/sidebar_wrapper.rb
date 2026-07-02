module PhlexKit
  # The page-level flex row that holds a PhlexKit::Sidebar + a PhlexKit::SidebarInset.
  # See sidebar.rb.
  class SidebarWrapper < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({ class: "pk-sidebar-wrapper" }, @attrs), &block)
    end
  end
end
