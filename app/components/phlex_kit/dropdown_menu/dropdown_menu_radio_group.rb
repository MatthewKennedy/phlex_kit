module PhlexKit
  # Exclusive-choice group of DropdownMenuRadioItems (share the same `name:`).
  # Ported from shadcn/ui's DropdownMenuRadioGroup. See dropdown_menu.rb.
  class DropdownMenuRadioGroup < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-dropdown-menu-group", role: "radiogroup" }, @attrs), &)
    end
  end
end
