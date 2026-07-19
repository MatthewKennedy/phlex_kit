module PhlexKit
  # The nested panel of a DropdownMenuSub — opens beside the trigger.
  # See dropdown_menu.rb.
  class DropdownMenuSubContent < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      base = { class: "pk-dropdown-menu-sub-content" }
      # Default only when the caller didn't supply their own — `mix` fuses.
      base[:role] = "menu" unless attr_set?(:role)
      div(**mix(base, @attrs)) do
        div(class: "pk-dropdown-menu-viewport", &)
      end
    end
  end
end
