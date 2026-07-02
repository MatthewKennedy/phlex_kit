module PhlexKit
  # See navigation_menu.rb.
  class NavigationMenuTrigger < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&block)
      button(**mix({
        type: :button,
        class: "pk-navigation-menu-trigger",
        aria: { haspopup: "menu", expanded: "false" },
        data: { action: "click->phlex-kit--menubar#toggle mouseenter->phlex-kit--menubar#switch" }
      }, @attrs)) do
        block&.call
        chevron
      end
    end

    private

    def chevron
      svg(xmlns: "http://www.w3.org/2000/svg", viewbox: "0 0 24 24", fill: "none",
          stroke: "currentColor", "stroke-width": "2", "stroke-linecap": "round",
          "stroke-linejoin": "round", class: "pk-navigation-menu-chevron", "aria-hidden": "true") do |s|
        s.path(d: "m6 9 6 6 6-6")
      end
    end
  end
end
