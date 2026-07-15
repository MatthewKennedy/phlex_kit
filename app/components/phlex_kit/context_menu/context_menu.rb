module PhlexKit
  # Right-click menu, positioned at the cursor with CSS. Ported from ruby_ui's
  # RubyUI::ContextMenu. Compose ContextMenu > (ContextMenuTrigger +
  # ContextMenuContent > ContextMenuItem/Label/Separator). phlex-kit--context-menu.
  class ContextMenu < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({
        class: "pk-context-menu",
        data: {
          controller: "phlex-kit--context-menu",
          # focusout: tabbing (or otherwise moving real focus) out of the
          # menu closes the open [popover=manual] panel (menubar's pattern).
          action: "focusout->phlex-kit--context-menu#onFocusout"
        }
      }, @attrs), &)
    end
  end
end
