module PhlexKit
  # The interactive element of a SidebarMenuItem. `as:` is :button (default) or :a
  # (pass `href:`); `active: true` marks the current page (drives the highlight via
  # data-active — a named kwarg, not an attr, since `mix` would merge a repeated
  # attribute rather than override; an active link also gets aria-current="page").
  # `tooltip:` labels the button while an icon-collapsed rail hides its text
  # (pure-CSS hover bubble) and doubles as the aria-label so the button keeps an
  # accessible name once the text is hidden. Bare block text is wrapped in a
  # <span> automatically so the collapsed rail's `> :not(svg)` rule can hide it;
  # blocks that emit their own markup (icon + <span>Label</span>) pass through
  # untouched — keep the label in a real element there. Attrs pass through via
  # mix. See sidebar.rb.
  class SidebarMenuButton < BaseComponent
    def initialize(as: :button, active: false, tooltip: nil, **attrs)
      @as = as
      @active = active
      @tooltip = tooltip
      @attrs = attrs
    end

    def view_template(&block)
      base = { class: "pk-sidebar-menu-button", "data-active": (@active ? "true" : "false") }
      base["aria-current"] = "page" if @active && @as == :a
      if @tooltip
        base["data-tooltip"] = @tooltip
        base["aria-label"] = @tooltip
      end
      send(@as, **mix(base, @attrs)) do
        # capture renders the block once; pure text (no markup) gets the span
        # wrapper the icon-collapsed CSS needs. The captured output is
        # already-escaped HTML, so re-emit it via raw(safe(...)).
        content = capture(&block)
        if content.include?("<") || content.empty?
          raw safe(content)
        else
          span { raw safe(content) }
        end
      end
    end
  end
end
