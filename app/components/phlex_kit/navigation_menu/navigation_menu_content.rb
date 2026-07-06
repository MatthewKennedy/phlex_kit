module PhlexKit
  # Hover panel of a NavigationMenuItem. See navigation_menu.rb.
  class NavigationMenuContent < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      # No role="menu" here — the panel holds plain links, not menuitems
      # (Radix/shadcn ship no menu role on NavigationMenu content either).
      div(**mix({ class: "pk-navigation-menu-content", popover: "manual" }, @attrs), &)
    end
  end
end
