module PhlexKit
  # Container for CommandGroups, with dividers between them. Carries the
  # listbox role and an id the controller points the input's aria-controls at
  # (and derives result ids from, for aria-activedescendant). See command.rb.
  class CommandList < BaseComponent
    # id: is a named kwarg (not left in **attrs) because `mix` would *merge* a
    # caller id with the generated one into an invalid two-token id, breaking
    # aria-controls (the documented list_id: wiring) and derived result ids.
    def initialize(id: nil, **attrs)
      @id = id || "pk-command-list-#{SecureRandom.hex(4)}"
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({
        id: @id,
        class: "pk-command-list",
        role: "listbox",
        data: { phlex_kit__command_target: "list" }
      }, @attrs), &)
    end
  end
end
