module PhlexKit
  # Plain link item (top-level or inside a panel). See navigation_menu.rb.
  class NavigationMenuLink < BaseComponent
    def initialize(href: "#", **attrs)
      @href = href
      @attrs = attrs
    end

    def view_template(&)
      a(**mix({ class: "pk-navigation-menu-link", href: @href }, @attrs), &)
    end
  end
end
