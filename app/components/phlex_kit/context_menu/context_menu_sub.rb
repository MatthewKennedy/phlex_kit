module PhlexKit
  # Nested submenu wrapper: SubTrigger row + SubContent panel, revealed on
  # hover/focus with pure CSS (no extra controller). Mirrors shadcn/ui's
  # ContextMenuSub. See context_menu.rb.
  class ContextMenuSub < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      # syncSub mirrors the CSS-driven reveal state onto the sub trigger's
      # aria-expanded (same wiring as DropdownMenuSub / MenubarSub).
      div(**mix({ class: "pk-context-menu-sub", data: { action: "mouseenter->phlex-kit--context-menu#syncSub mouseleave->phlex-kit--context-menu#syncSub focusin->phlex-kit--context-menu#syncSub focusout->phlex-kit--context-menu#syncSub" } }, @attrs), &)
    end
  end
end
