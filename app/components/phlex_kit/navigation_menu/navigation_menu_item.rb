module PhlexKit
  # See navigation_menu.rb.
  class NavigationMenuItem < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      li(**mix({ class: "pk-navigation-menu-item", data: { phlex_kit__menubar_target: "menu" } }, @attrs), &)
    end
  end
end
