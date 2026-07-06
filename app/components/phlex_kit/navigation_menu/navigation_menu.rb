module PhlexKit
  # Site navigation with hoverable panels, ported from shadcn/ui's
  # NavigationMenu. Shares the phlex-kit--menubar controller in hover-open mode
  # (data-hover-open). Compose NavigationMenu > NavigationMenuList >
  # NavigationMenuItem > (NavigationMenuTrigger + NavigationMenuContent |
  # NavigationMenuLink). `.pk-navigation-menu*` (navigation_menu.css).
  class NavigationMenu < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      nav(**mix({
        class: "pk-navigation-menu",
        data: {
          controller: "phlex-kit--menubar",
          hover_open: true,
          action: "click@window->phlex-kit--menubar#onClickOutside keydown.esc->phlex-kit--menubar#close mouseleave->phlex-kit--menubar#closeSoon"
        }
      }, @attrs), &)
    end
  end
end
