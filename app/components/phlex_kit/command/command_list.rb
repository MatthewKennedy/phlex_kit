module PhlexKit
  # Container for CommandGroups, with dividers between them. See command.rb.
  class CommandList < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({ class: "pk-command-list" }, @attrs), &)
    end
  end
end
