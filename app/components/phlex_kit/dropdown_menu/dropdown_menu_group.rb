module PhlexKit
  # Grouping wrapper for related items (with an optional leading
  # DropdownMenuLabel). Ported from shadcn/ui's DropdownMenuGroup.
  # See dropdown_menu.rb.
  class DropdownMenuGroup < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-dropdown-menu-group", role: "group" }, @attrs), &)
    end
  end
end
