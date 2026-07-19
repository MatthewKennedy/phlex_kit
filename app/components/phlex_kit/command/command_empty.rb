module PhlexKit
  # "No results" row — revealed by the controller only when a filter matches
  # nothing. Server-rendered with pk-hidden so an inline palette doesn't flash
  # "No results" under its items before Stimulus connects, and doesn't show it
  # permanently with JS disabled. See command.rb.
  class CommandEmpty < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({
        class: "pk-command-empty pk-hidden",
        role: "presentation",
        data: { phlex_kit__command_target: "empty" }
      }, @attrs), &)
    end
  end
end
