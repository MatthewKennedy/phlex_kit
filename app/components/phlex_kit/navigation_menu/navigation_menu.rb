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
          # onKeydown (not keydown.esc->close): the shared handler drives
          # arrow-key navigation over the panels AND closes on Escape with
          # focus returned to the trigger (bare #close as an action received
          # the event as `opts`, so refocus never happened — focus fell to
          # <body> when the panel hid).
          # mouseenter->cancelClose: re-entering the nav over list padding /
          # whitespace must cancel the pending mouseleave grace-close (only
          # trigger/panel mouseenter did before).
          action: "click@window->phlex-kit--menubar#onClickOutside keydown->phlex-kit--menubar#onKeydown mouseleave->phlex-kit--menubar#closeSoon mouseenter->phlex-kit--menubar#cancelClose"
        }
      }, @attrs), &)
    end
  end
end
