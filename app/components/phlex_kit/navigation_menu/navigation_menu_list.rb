module PhlexKit
  # See navigation_menu.rb.
  class NavigationMenuList < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = ul(**mix({ class: "pk-navigation-menu-list" }, @attrs), &)
  end
end
