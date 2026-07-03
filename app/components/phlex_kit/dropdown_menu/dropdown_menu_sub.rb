module PhlexKit
  # Nested submenu wrapper: SubTrigger row + SubContent panel, revealed on
  # hover/focus with pure CSS (no extra controller). Ported from shadcn/ui's
  # DropdownMenuSub. See dropdown_menu.rb.
  class DropdownMenuSub < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-dropdown-menu-sub" }, @attrs), &)
    end
  end
end
