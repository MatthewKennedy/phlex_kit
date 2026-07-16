module PhlexKit
  # Plain link item (top-level or inside a panel). Hover fires #switch like a
  # trigger: for a TOP-LEVEL link the closest menu item has no panel, so an
  # open sibling panel closes; for a link INSIDE a panel the closest item IS
  # the open menu, so switch is a no-op and the panel stays. See
  # navigation_menu.rb.
  class NavigationMenuLink < BaseComponent
    def initialize(href: "#", **attrs)
      @href = href
      @attrs = attrs
    end

    def view_template(&)
      a(**mix({
        class: "pk-navigation-menu-link",
        href: @href,
        # click: closes the open panel on real activation (and swallows the
        # default href="#" the way dropdown_menu_controller.js's close() does
        # — see menubar_controller.js#close).
        data: { action: "mouseenter->phlex-kit--menubar#switch click->phlex-kit--menubar#close" }
      }, @attrs), &)
    end
  end
end
