module PhlexKit
  # The row that opens a ContextMenuSub (trailing ▸ chevron). See context_menu.rb.
  class ContextMenuSubTrigger < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&block)
      div(**mix({
        class: "pk-context-menu-item pk-context-menu-sub-trigger",
        role: "menuitem",
        # -1: roving focus reaches it via arrows (focus-within opens the sub);
        # tabindex 0 made it a stray tab stop inside the menu.
        tabindex: "-1",
        aria: { haspopup: "menu" },
        data: { phlex_kit__context_menu_target: "menuItem" }
      }, @attrs)) do
        block&.call
        render Icon.new(:chevron_right, size: nil, class: "pk-context-menu-sub-chevron")
      end
    end
  end
end
