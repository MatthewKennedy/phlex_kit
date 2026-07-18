module PhlexKit
  # A horizontal divider between groups of PhlexKit::DropdownMenuItems. See dropdown_menu.rb.
  class DropdownMenuSeparator < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      base = { class: "pk-dropdown-menu-separator" }
      # Defaults only when the caller didn't supply their own — `mix` fuses,
      # and aria_key_set? covers the aria: hash spelling the flat key missed.
      base[:role] = "separator" unless attr_set?(:role)
      base[:"aria-orientation"] = "horizontal" unless aria_key_set?(:orientation)
      div(**mix(base, @attrs))
    end
  end
end
