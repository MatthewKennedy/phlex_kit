module PhlexKit
  # The interactive element of a SidebarMenuItem. `as:` is :button (default) or :a
  # (pass `href:`); `active: true` marks the current page (drives the highlight via
  # data-active — a named kwarg, not an attr, since `mix` would merge a repeated
  # attribute rather than override). `tooltip:` labels the button while an
  # icon-collapsed rail hides its text (pure-CSS hover bubble). Attrs pass
  # through via mix. See sidebar.rb.
  class SidebarMenuButton < BaseComponent
    def initialize(as: :button, active: false, tooltip: nil, **attrs)
      @as = as
      @active = active
      @tooltip = tooltip
      @attrs = attrs
    end

    def view_template(&block)
      base = { class: "pk-sidebar-menu-button", "data-active": (@active ? "true" : "false") }
      base["data-tooltip"] = @tooltip if @tooltip
      send(@as, **mix(base, @attrs), &block)
    end
  end
end
