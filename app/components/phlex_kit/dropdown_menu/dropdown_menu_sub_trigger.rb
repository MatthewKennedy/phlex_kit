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
        render Icon.new(:chevron_right, size: nil, class: "pk-dropdown-menu-sub-chevron")
      end
    end
  end
end
