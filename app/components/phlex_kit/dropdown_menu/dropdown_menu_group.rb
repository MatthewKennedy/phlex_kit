module PhlexKit
  # Grouping wrapper for related items (with an optional leading
  # DropdownMenuLabel). Ported from shadcn/ui's DropdownMenuGroup.
  # See dropdown_menu.rb.
  class DropdownMenuGroup < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      base = { class: "pk-dropdown-menu-group" }
      # Default only when the caller didn't supply their own — `mix` fuses.
      base[:role] = "group" unless attr_set?(:role)
      div(**mix(base, @attrs), &)
    end
  end
end
