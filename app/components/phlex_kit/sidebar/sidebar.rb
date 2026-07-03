module PhlexKit
  # Sidebar shell, ported from ruby_ui's RubyUI::Sidebar at `collapsible: :none`
  # (the NonCollapsibleSidebar path): a static flex-column rail. Deliberately
  # WITHOUT ruby_ui's collapsible/offcanvas Stimulus controller + cookie state +
  # mobile Sheet (the admin sidebar is static) — those can be added later if a
  # collapsible chrome is wanted. The static part set matches shadcn/ui's Sidebar:
  # compose with SidebarWrapper (the page root) + SidebarHeader / SidebarContent /
  # SidebarGroup (+ Label / Content / Action) / SidebarMenu (+ Item / Button /
  # Action / Badge / Skeleton / Sub / SubItem / SubButton) / SidebarSeparator /
  # SidebarInput / SidebarFooter, alongside a SidebarInset for the main content.
  # Tailwind → vanilla `.pk-sidebar*` (sidebar.css).
  class Sidebar < BaseComponent
    # Active-item treatment (ui.shadcn.com/create's "Menu" option): :default is
    # shadcn's stock accent tint; :solid fills with the primary/brand role.
    MENUS = { default: nil, solid: "menu-solid" }.freeze

    def initialize(menu: :default, **attrs)
      @menu = menu.to_sym
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({ class: classes }, @attrs), &block)
    end

    private

    def classes
      [ "pk-sidebar", MENUS.fetch(@menu) ].compact.join(" ")
    end
  end
end
