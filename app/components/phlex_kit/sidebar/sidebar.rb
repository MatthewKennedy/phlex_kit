module PhlexKit
  # Sidebar shell, ported from ruby_ui's RubyUI::Sidebar at `collapsible: :none`
  # (the NonCollapsibleSidebar path): a static flex-column rail. Deliberately
  # WITHOUT ruby_ui's collapsible/offcanvas Stimulus controller + cookie state +
  # mobile Sheet (the admin sidebar is static) — those can be added later if a
  # collapsible chrome is wanted. Compose with SidebarWrapper (the page root) +
  # SidebarHeader / SidebarContent / SidebarMenu (+ Item / Button) / SidebarFooter,
  # alongside a SidebarInset for the main content. Tailwind → vanilla `.pk-sidebar*`
  # (sidebar.css).
  class Sidebar < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({ class: "pk-sidebar" }, @attrs), &block)
    end
  end
end
