module PhlexKit
  # Right-aligned keyboard hint on a CommandItem, ported from shadcn/ui's
  # CommandShortcut. See command.rb.
  class CommandShortcut < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      span(**mix({ class: "pk-command-shortcut" }, @attrs), &block)
    end
  end
end
