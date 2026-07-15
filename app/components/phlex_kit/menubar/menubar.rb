module PhlexKit
  # Desktop-style menu bar, ported from shadcn/ui's Menubar (Radix replaced by
  # the phlex-kit--menubar controller: click opens a menu, hover switches
  # between open menus, Escape/outside closes). Compose Menubar > MenubarMenu >
  # (MenubarTrigger + MenubarContent > MenubarItem/MenubarSeparator).
  # NavigationMenu shares the controller in hover mode. `.pk-menubar*`
  # (menubar.css).
  class Menubar < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({
        class: "pk-menubar",
        role: "menubar",
        data: {
          controller: "phlex-kit--menubar",
          # focusout: tabbing out of the bar closes the open [popover=manual]
          # panel (which no focus trap holds open).
          action: "click@window->phlex-kit--menubar#onClickOutside keydown->phlex-kit--menubar#onKeydown focusout->phlex-kit--menubar#onFocusout"
        }
      }, @attrs), &)
    end
  end
end
