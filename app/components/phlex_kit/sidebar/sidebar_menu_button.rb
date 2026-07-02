module PhlexKit
  # The interactive element of a SidebarMenuItem. `as:` is :button (default) or :a
  # (pass `href:`); `active: true` marks the current page (drives the highlight via
  # data-active — a named kwarg, not an attr, since `mix` would merge a repeated
  # attribute rather than override). Attrs pass through via mix. See sidebar.rb.
  class SidebarMenuButton < BaseComponent
    def initialize(as: :button, active: false, **attrs)
      @as = as
      @active = active
      @attrs = attrs
    end

    def view_template(&block)
      send(@as, **mix({ class: "pk-sidebar-menu-button", "data-active": (@active ? "true" : "false") }, @attrs), &block)
    end
  end
end
