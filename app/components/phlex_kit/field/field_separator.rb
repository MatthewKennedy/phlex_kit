module PhlexKit
  # Hairline between FieldGroups, optionally with centered text riding the
  # line ("Or continue with"), ported from shadcn/ui's FieldSeparator.
  # See field.rb.
  class FieldSeparator < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)

    def view_template(&block)
      div(**mix({ class: "pk-field-separator" }, @attrs)) do
        render Separator.new(class: "pk-field-separator-line")
        span(class: "pk-field-separator-content", &block) if block
      end
    end
  end
end
