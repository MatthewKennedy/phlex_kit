module PhlexKit
  class ContextMenuTrigger < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      # tabindex 0 so the keyboard context-menu key (Menu / Shift+F10) can
      # reach it, and so Escape has somewhere to return focus to.
      div(**mix({ class: "pk-context-menu-trigger", tabindex: "0", data: { phlex_kit__context_menu_target: "trigger", action: "contextmenu->phlex-kit--context-menu#open" } }, @attrs), &)
    end
  end
end
