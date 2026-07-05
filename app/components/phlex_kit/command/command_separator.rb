module PhlexKit
  # Hairline between CommandGroups, ported from shadcn/ui's CommandSeparator.
  # Hidden while a filter query is active (like cmdk). See command.rb.
  class CommandSeparator < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      div(**mix({
        class: "pk-command-separator",
        role: "separator",
        aria: { hidden: true },
        data: { phlex_kit__command_target: "separator" }
      }, @attrs))
    end
  end
end
