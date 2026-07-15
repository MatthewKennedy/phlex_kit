module PhlexKit
  # Nested submenu wrapper: SubTrigger row + SubContent panel, revealed on
  # hover/focus with pure CSS (no extra controller). Ported from shadcn/ui's
  # DropdownMenuSub. See dropdown_menu.rb.
  class DropdownMenuSub < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      # syncSub mirrors the CSS-driven reveal state onto the sub trigger's
      # aria-expanded (same wiring as MenubarSub).
      div(**mix({ class: "pk-dropdown-menu-sub", data: { action: "mouseenter->phlex-kit--dropdown-menu#syncSub mouseleave->phlex-kit--dropdown-menu#syncSub focusin->phlex-kit--dropdown-menu#syncSub focusout->phlex-kit--dropdown-menu#syncSub" } }, @attrs), &)
    end
  end
end
