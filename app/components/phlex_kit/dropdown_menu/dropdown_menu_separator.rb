module PhlexKit
  # A horizontal divider between groups of PhlexKit::DropdownMenuItems. See dropdown_menu.rb.
  class DropdownMenuSeparator < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      div(**mix({ role: "separator", "aria-orientation": "horizontal", class: "pk-dropdown-menu-separator" }, @attrs))
    end
  end
end
