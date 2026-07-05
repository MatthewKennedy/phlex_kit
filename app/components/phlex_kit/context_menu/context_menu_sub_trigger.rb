module PhlexKit
  # The row that opens a ContextMenuSub (trailing ▸ chevron). See context_menu.rb.
  class ContextMenuSubTrigger < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&block)
      div(**mix({
        class: "pk-context-menu-item pk-context-menu-sub-trigger",
        role: "menuitem",
        tabindex: "0",
        aria: { haspopup: "menu" }
      }, @attrs)) do
        block&.call
        render Icon.new(:chevron_right, size: nil, class: "pk-context-menu-sub-chevron")
      end
    end
  end
end
