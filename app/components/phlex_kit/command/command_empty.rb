module PhlexKit
  # "No results" row — hidden by the controller until a filter matches nothing.
  # See command.rb.
  class CommandEmpty < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({
        class: "pk-command-empty",
        role: "presentation",
        data: { phlex_kit__command_target: "empty" }
      }, @attrs), &)
    end
  end
end
