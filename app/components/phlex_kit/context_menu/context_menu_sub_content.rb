module PhlexKit
  # The nested panel of a ContextMenuSub — opens beside the trigger.
  # See context_menu.rb.
  class ContextMenuSubContent < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-context-menu-sub-content", role: "menu" }, @attrs)) do
        div(class: "pk-context-menu-sub-viewport", &)
      end
    end
  end
end
