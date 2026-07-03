module PhlexKit
  # The row that opens a DropdownMenuSub (trailing ▸ chevron). See
  # dropdown_menu.rb.
  class DropdownMenuSubTrigger < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&block)
      div(**mix({
        class: "pk-dropdown-menu-item pk-dropdown-menu-sub-trigger",
        role: "menuitem",
        tabindex: "0",
        aria: { haspopup: "menu" }
      }, @attrs)) do
        block&.call
        svg(xmlns: "http://www.w3.org/2000/svg", viewbox: "0 0 24 24", fill: "none", stroke: "currentColor",
            "stroke-width": "2", "stroke-linecap": "round", "stroke-linejoin": "round",
            class: "pk-dropdown-menu-sub-chevron", "aria-hidden": "true") do |s|
          s.path(d: "m9 18 6-6-6-6")
        end
      end
    end
  end
end
