module PhlexKit
  # Right-aligned keyboard hint in a menu row. Ported from shadcn/ui's
  # DropdownMenuShortcut. See dropdown_menu.rb.
  class DropdownMenuShortcut < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      span(**mix({ class: "pk-dropdown-menu-shortcut" }, @attrs), &)
    end
  end
end
