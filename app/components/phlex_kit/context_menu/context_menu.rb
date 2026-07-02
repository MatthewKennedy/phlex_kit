module PhlexKit
  # Right-click menu, positioned at the cursor with CSS. Ported from ruby_ui's
  # RubyUI::ContextMenu. Compose ContextMenu > (ContextMenuTrigger +
  # ContextMenuContent > ContextMenuItem/Label/Separator). phlex-kit--context-menu.
  class ContextMenu < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-context-menu", data: { controller: "phlex-kit--context-menu" } }, @attrs), &)
    end
  end
end
