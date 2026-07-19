module PhlexKit
  # The row that opens a DropdownMenuSub (trailing ▸ chevron). See
  # dropdown_menu.rb.
  class DropdownMenuSubTrigger < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&block)
      base = {
        class: "pk-dropdown-menu-item pk-dropdown-menu-sub-trigger",
        data: { phlex_kit__dropdown_menu_target: "menuItem" }
      }
      # Defaults only when the caller didn't supply their own — `mix` fuses.
      base[:role] = "menuitem" unless attr_set?(:role)
      # -1: roving focus reaches it via arrows (focus-within opens the sub);
      # tabindex 0 made it a stray tab stop inside the menu.
      base[:tabindex] = "-1" unless attr_set?(:tabindex)
      base[:"aria-haspopup"] = "menu" unless aria_key_set?(:haspopup)
      # expanded starts false and is mirrored live by the controller's
      # syncSub (the reveal itself is pure CSS :hover/:focus-within).
      base[:"aria-expanded"] = "false" unless aria_key_set?(:expanded)
      div(**mix(base, @attrs)) do
        block&.call
        render Icon.new(:chevron_right, size: nil, class: "pk-dropdown-menu-sub-chevron")
      end
    end
  end
end
