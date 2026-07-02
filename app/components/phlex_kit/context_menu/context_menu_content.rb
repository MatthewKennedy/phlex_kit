module PhlexKit
  class ContextMenuContent < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-context-menu-content pk-hidden", role: "menu", tabindex: "-1", aria: { orientation: "vertical" }, data: { phlex_kit__context_menu_target: "content", state: "closed" } }, @attrs), &)
    end
  end
end
