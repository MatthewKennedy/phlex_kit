module PhlexKit
  # Exclusive-choice group of ContextMenuRadioItems (share the same `name:`).
  # Mirrors shadcn/ui's ContextMenuRadioGroup. See context_menu.rb.
  class ContextMenuRadioGroup < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-context-menu-group", role: "radiogroup" }, @attrs), &)
    end
  end
end
