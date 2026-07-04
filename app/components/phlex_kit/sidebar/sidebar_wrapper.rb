module PhlexKit
  # The page-level flex row that holds a PhlexKit::Sidebar + a PhlexKit::SidebarInset.
  #
  # `collapsible:` (shadcn/ui's Sidebar `collapsible` prop, held here because the
  # wrapper is the Stimulus scope shared by rail, trigger and scrim):
  #   :none      — static rail (default).
  #   :offcanvas — the rail hides/reveals via a PhlexKit::SidebarTrigger. On
  #                desktop it slides out of the layout; below 768px it overlays
  #                as a fixed drawer behind a click-to-close scrim, closed by
  #                Escape and before Turbo caches the page. State is DOM-only:
  #                `data-collapsed` (desktop) / `data-open` (mobile drawer).
  # See sidebar.rb.
  class SidebarWrapper < BaseComponent
    COLLAPSIBLE = { none: nil, offcanvas: "collapsible-offcanvas" }.freeze

    def initialize(collapsible: :none, **attrs)
      @collapsible = collapsible.to_sym
      @attrs = attrs
    end

    def view_template(&block)
      unless offcanvas?
        return div(**mix({ class: classes }, @attrs), &block)
      end

      div(**mix({
        class: classes,
        data: {
          controller: "phlex-kit--sidebar",
          action: "keydown.esc@window->phlex-kit--sidebar#closeMobile " \
                  "turbo:before-cache@window->phlex-kit--sidebar#closeMobile"
        }
      }, @attrs)) do
        yield if block
        button(type: :button, class: "pk-sidebar-scrim", aria_label: "Close sidebar",
               tabindex: "-1", data: { action: "click->phlex-kit--sidebar#closeMobile" })
      end
    end

    private

    def offcanvas? = @collapsible == :offcanvas

    def classes
      [ "pk-sidebar-wrapper", COLLAPSIBLE.fetch(@collapsible) ].compact.join(" ")
    end
  end
end
