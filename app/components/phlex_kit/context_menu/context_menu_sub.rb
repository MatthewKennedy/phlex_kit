module PhlexKit
  # Nested submenu wrapper: SubTrigger row + SubContent panel, revealed on
  # hover/focus with pure CSS (no extra controller). Mirrors shadcn/ui's
  # ContextMenuSub. See context_menu.rb.
  class ContextMenuSub < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-context-menu-sub" }, @attrs), &)
    end
  end
end
