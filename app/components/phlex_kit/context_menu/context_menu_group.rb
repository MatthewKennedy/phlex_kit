module PhlexKit
  # Grouping wrapper for related rows (with an optional leading
  # ContextMenuLabel). Mirrors shadcn/ui's ContextMenuGroup. See context_menu.rb.
  class ContextMenuGroup < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      base = { class: "pk-context-menu-group" }
      # Default only when the caller didn't supply their own — `mix` fuses.
      base[:role] = "group" unless attr_set?(:role)
      div(**mix(base, @attrs), &)
    end
  end
end
