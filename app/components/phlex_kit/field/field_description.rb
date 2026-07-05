module PhlexKit
  # Muted helper text under (or beside) a Field's control, ported from
  # shadcn/ui's FieldDescription. See field.rb.
  class FieldDescription < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      p(**mix({ class: "pk-field-description", data: { slot: "field-description" } }, @attrs), &)
    end
  end
end
