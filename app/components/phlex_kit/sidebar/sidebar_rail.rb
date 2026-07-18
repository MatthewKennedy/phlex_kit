module PhlexKit
  # Invisible grab strip along the sidebar's trailing edge — clicking it
  # toggles the collapse, like shadcn/ui's SidebarRail. Place it as the last
  # child of a Sidebar inside a collapsible wrapper. `expanded:` renders the
  # initial aria-expanded (pass false when the wrapper starts
  # default_collapsed); the phlex-kit--sidebar controller keeps it in sync on
  # toggle. `controls:` renders aria-controls pointing at the Sidebar's id —
  # when omitted, the controller wires it on connect. See sidebar.rb.
  class SidebarRail < BaseComponent
    def initialize(expanded: true, controls: nil, **attrs)
      @expanded = expanded
      @controls = controls
      @attrs = attrs
    end

    def view_template
      base = {
        type: :button,
        class: "pk-sidebar-rail",
        "aria-expanded": @expanded ? "true" : "false",
        tabindex: "-1",
        data: { action: "click->phlex-kit--sidebar#toggle" }
      }
      # Defaults only when the caller didn't supply their own — `mix` fuses.
      base[:aria_label] = "Toggle sidebar" unless aria_labelled?
      base[:title] = "Toggle sidebar" unless attr_set?(:title)
      base["aria-controls"] = @controls if @controls
      button(**mix(base, @attrs))
    end
  end
end
