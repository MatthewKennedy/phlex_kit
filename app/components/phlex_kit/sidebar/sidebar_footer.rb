module PhlexKit
  # Bottom region of a PhlexKit::Sidebar (user identity + sign out). See sidebar.rb.
  class SidebarFooter < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({ class: "pk-sidebar-footer" }, @attrs), &block)
    end
  end
end
