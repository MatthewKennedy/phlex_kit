module PhlexKit
  # Container for CommandGroups, with dividers between them. Carries the
  # listbox role and an id the controller points the input's aria-controls at
  # (and derives result ids from, for aria-activedescendant). See command.rb.
  class CommandList < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({
        id: "pk-command-list-#{SecureRandom.hex(4)}",
        class: "pk-command-list",
        role: "listbox",
        data: { phlex_kit__command_target: "list" }
      }, @attrs), &)
    end
  end
end
