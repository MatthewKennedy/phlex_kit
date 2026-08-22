module PhlexKit
  # The page-level flex row that holds a PhlexKit::Sidebar + a PhlexKit::SidebarInset.
  #
  # `collapsible:` (shadcn/ui's Sidebar `collapsible` prop, held here because the
  # wrapper is the Stimulus scope shared by rail, trigger and scrim):
  #   :none      — static rail (default).
  #   :offcanvas — the rail hides/reveals via a PhlexKit::SidebarTrigger. On
  #                desktop it slides out of the layout; below 768px it overlays
  #                as a fixed drawer behind a click-to-close scrim, closed by
  #                Escape and before Turbo caches the page.
  #   :icon      — like :offcanvas, but on desktop the rail collapses to a
  #                3rem icon strip instead of leaving: labels hide, menu
  #                buttons become icon squares (add `tooltip:` to
  #                SidebarMenuButton for hover labels), groups/badges/subs
  #                disappear. Mobile behaves like :offcanvas.
  #
  # State is DOM-only: `data-collapsed` (desktop) / `data-open` (mobile
  # drawer). ⌘B/Ctrl+B toggles. The desktop state persists in a
  # `pk_sidebar_state` cookie ("collapsed"/"expanded") — pass
  # `default_collapsed: cookies[:pk_sidebar_state] == "collapsed"` from the
  # host layout to render the collapsed rail server-side with no flash.
  # Add a PhlexKit::SidebarRail inside the Sidebar for the edge grab-strip.
  # `side:` is logical — :start (default) pins it to the reading-start edge,
  # :end to the far edge; both flip with the document direction.
  # See sidebar.rb.
  class SidebarWrapper < BaseComponent
    COLLAPSIBLE = { none: nil, offcanvas: "collapsible-offcanvas", icon: "collapsible-icon" }.freeze
    # Logical, not physical: :start is the reading-start edge (left in LTR,
    # right in RTL), so a bare sidebar follows the document direction. The
    # CSS is written in logical properties to match — physical :left/:right
    # deliberately raise.
    SIDES = { start: nil, end: "side-end" }.freeze

    def initialize(collapsible: :none, side: :start, default_collapsed: false, **attrs)
      @collapsible = collapsible.to_sym
      @side = side.to_sym
      @default_collapsed = default_collapsed
      @attrs = attrs
    end

    def view_template(&block)
      unless collapsible?
        return div(**mix({ class: classes }, @attrs), &block)
      end

      base = {
        class: classes,
        data: {
          controller: "phlex-kit--sidebar",
          action: "keydown.esc@window->phlex-kit--sidebar#closeMobile " \
                  "keydown.meta+b@window->phlex-kit--sidebar#toggle:prevent " \
                  "keydown.ctrl+b@window->phlex-kit--sidebar#toggle:prevent " \
                  "turbo:before-cache@window->phlex-kit--sidebar#closeMobile"
        }
      }
      base["data-collapsed"] = "" if @default_collapsed

      div(**mix(base, @attrs)) do
        yield if block
        button(type: :button, class: "pk-sidebar-scrim", aria_label: "Close sidebar",
               tabindex: "-1", data: { action: "click->phlex-kit--sidebar#closeMobile" })
      end
    end

    private

    def collapsible? = @collapsible != :none

    def classes
      [ "pk-sidebar-wrapper", fetch_option(COLLAPSIBLE, @collapsible, :collapsible),
        fetch_option(SIDES, @side, :side) ].compact.join(" ")
    end
  end
end
