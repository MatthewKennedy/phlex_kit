module PhlexKit
  # Right-aligned keyboard hint on a ContextMenuItem, mirroring shadcn/ui's
  # ContextMenuShortcut (the item's `shortcut:` param renders the same span).
  # See context_menu.rb.
  class ContextMenuShortcut < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&block)
      span(**mix({ class: "pk-context-menu-shortcut" }, @attrs), &block)
    end
  end
end
