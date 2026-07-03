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
      render Icon.new(:chevron_down, size: nil, class: "pk-navigation-menu-chevron")
    end
  end
end
