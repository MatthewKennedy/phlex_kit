module PhlexKit
  # Right-aligned keyboard hint on a MenubarItem (the item's `shortcut:` param
  # renders the same span). Mirrors shadcn/ui's MenubarShortcut. See menubar.rb.
  class MenubarShortcut < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&block)
      span(**mix({ class: "pk-menubar-shortcut" }, @attrs), &block)
    end
  end
end
