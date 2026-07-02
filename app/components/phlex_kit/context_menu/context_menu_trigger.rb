module PhlexKit
  class ContextMenuTrigger < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-context-menu-trigger", data: { phlex_kit__context_menu_target: "trigger", action: "contextmenu->phlex-kit--context-menu#open" } }, @attrs), &)
    end
  end
end
