module PhlexKit
  # Titled group of CommandItems. Hidden by the controller when filtering leaves
  # it empty. The heading keeps ruby_ui's [group-heading] attribute (styled via
  # the attribute selector in command.css). See command.rb.
  class CommandGroup < BaseComponent
    def initialize(title: nil, **attrs)
      @title = title
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({
        class: "pk-command-group",
        role: "presentation",
        data: { value: @title, phlex_kit__command_target: "group" }
      }, @attrs)) do
        render_header if @title
        render_items(&block)
      end
    end

    private

    def render_header
      div(group_heading: @title) { @title }
    end

    def render_items(&)
      div(group_items: "", role: "group", &)
    end
  end
end
