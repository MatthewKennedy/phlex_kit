module PhlexKit
  # A menu row in a PhlexKit::DropdownMenuContent. `as: :a` (default, pass `href:`) or
  # `:div` (e.g. to wrap a button_to). Closes the menu on click. See dropdown_menu.rb.
  class DropdownMenuItem < BaseComponent
    def initialize(as: :a, href: "#", **attrs)
      @as = as.to_sym
      @href = href
      @attrs = attrs
    end

    def view_template(&block)
      base = {
        role: "menuitem",
        tabindex: "-1",
        class: "pk-dropdown-menu-item",
        data: { phlex_kit__dropdown_menu_target: "menuItem", action: "click->phlex-kit--dropdown-menu#close" }
      }
      base[:href] = @href unless @as == :div
      send(@as, **mix(base, @attrs), &block)
    end
  end
end
