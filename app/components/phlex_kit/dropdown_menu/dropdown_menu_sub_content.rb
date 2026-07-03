module PhlexKit
  # The nested panel of a DropdownMenuSub — opens beside the trigger.
  # See dropdown_menu.rb.
  class DropdownMenuSubContent < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-dropdown-menu-sub-content", role: "menu" }, @attrs)) do
        div(class: "pk-dropdown-menu-viewport", &)
      end
    end
  end
end
