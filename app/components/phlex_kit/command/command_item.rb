module PhlexKit
  # One palette result — an <a> (pass `href:`) filtered by `value:`, activated
  # by click or enter. aria-selected is toggled by keyboard navigation.
  # See command.rb.
  class CommandItem < BaseComponent
    def initialize(value:, text: "", href: "#", **attrs)
      @value = value
      @text = text
      @href = href
      @attrs = attrs
    end

    def view_template(&)
      a(**mix({
        class: "pk-command-item",
        href: @href,
        role: "option",
        data: { phlex_kit__command_target: "item", value: @value, text: @text }
      }, @attrs), &)
    end
  end
end
