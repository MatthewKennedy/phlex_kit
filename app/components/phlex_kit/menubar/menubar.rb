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
      base = {
        class: "pk-menubar",
        data: {
          controller: "phlex-kit--menubar",
          # focusout: tabbing out of the bar closes the open [popover=manual]
          # panel (which no focus trap holds open).
          # mousedown@window arms the modal-menu click swallow (deliberately
          # NOT bound by navigation_menu.rb — nav menus are non-modal).
          action: "mousedown@window->phlex-kit--menubar#onMousedownOutside click@window->phlex-kit--menubar#onClickOutside keydown->phlex-kit--menubar#onKeydown focusout->phlex-kit--menubar#onFocusout"
        }
      }
      # Default only when the caller didn't supply their own — `mix` fuses.
      base[:role] = "menubar" unless attr_set?(:role)
      div(**mix(base, @attrs), &)
    end
  end
end
