module PhlexKit
  # Stacks a FieldTitle/FieldLabel + FieldDescription beside a control in a
  # horizontal Field (e.g. checkbox rows with helper text), ported from
  # shadcn/ui's FieldContent. See field.rb.
  class FieldContent < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-field-content", data: { slot: "field-content" } }, @attrs), &)
    end
  end
end
