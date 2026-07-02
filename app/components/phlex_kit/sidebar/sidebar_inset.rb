module PhlexKit
  # The main content region beside a PhlexKit::Sidebar (renders <main>, flex-1). Pass
  # `class: "main"` to keep the app's existing content padding/typography.
  # See sidebar.rb.
  class SidebarInset < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      main(**mix({ class: "pk-sidebar-inset" }, @attrs), &block)
    end
  end
end
