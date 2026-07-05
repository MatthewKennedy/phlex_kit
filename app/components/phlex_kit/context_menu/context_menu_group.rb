module PhlexKit
  # Grouping wrapper for related rows (with an optional leading
  # ContextMenuLabel). Mirrors shadcn/ui's ContextMenuGroup. See context_menu.rb.
  class ContextMenuGroup < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-context-menu-group", role: "group" }, @attrs), &)
    end
  end
end
