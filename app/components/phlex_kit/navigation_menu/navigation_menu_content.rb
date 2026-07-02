module PhlexKit
  # Hover panel of a NavigationMenuItem. See navigation_menu.rb.
  class NavigationMenuContent < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-navigation-menu-content pk-hidden", role: "menu" }, @attrs), &)
    end
  end
end
