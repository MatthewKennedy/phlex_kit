module PhlexKit
  # Exclusive-choice group of ContextMenuRadioItems (share the same `name:`).
  # Mirrors shadcn/ui's ContextMenuRadioGroup. See context_menu.rb.
  class ContextMenuRadioGroup < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      base = { class: "pk-context-menu-group" }
      # Default only when the caller didn't supply their own — `mix` fuses.
      base[:role] = "radiogroup" unless attr_set?(:role)
      div(**mix(base, @attrs), &)
    end
  end
end
