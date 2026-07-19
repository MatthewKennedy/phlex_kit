module PhlexKit
  # The nested panel of a ContextMenuSub — opens beside the trigger.
  # See context_menu.rb.
  class ContextMenuSubContent < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      base = { class: "pk-context-menu-sub-content" }
      # Default only when the caller didn't supply their own — `mix` fuses.
      base[:role] = "menu" unless attr_set?(:role)
      div(**mix(base, @attrs)) do
        div(class: "pk-context-menu-sub-viewport", &)
      end
    end
  end
end
