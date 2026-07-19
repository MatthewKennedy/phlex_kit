module PhlexKit
  # Exclusive-choice group of DropdownMenuRadioItems (share the same `name:`).
  # Ported from shadcn/ui's DropdownMenuRadioGroup. See dropdown_menu.rb.
  class DropdownMenuRadioGroup < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      base = { class: "pk-dropdown-menu-group" }
      # Default only when the caller didn't supply their own — `mix` fuses.
      base[:role] = "radiogroup" unless attr_set?(:role)
      div(**mix(base, @attrs), &)
    end
  end
end
