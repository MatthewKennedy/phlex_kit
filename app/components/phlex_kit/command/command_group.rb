module PhlexKit
  # Titled group of CommandItems. Hidden by the controller when filtering leaves
  # it empty. The heading keeps ruby_ui's [group-heading] attribute (styled via
  # the attribute selector in command.css). See command.rb.
  class CommandGroup < BaseComponent
    def initialize(title: nil, **attrs)
      @title = title
      # Names the role="group" items wrapper via aria-labelledby → heading id
      # (matches cmdk/shadcn; id pattern mirrors CommandList).
      @heading_id = "pk-command-group-heading-#{SecureRandom.hex(4)}" if title
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
      div(id: @heading_id, group_heading: @title) { @title }
    end

    def render_items(&)
      div(group_items: "", role: "group", aria_labelledby: @heading_id, &)
    end
  end
end
