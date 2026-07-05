module PhlexKit
  # Label-looking title that is NOT a <label> (for content inside a
  # FieldLabel-wrapped choice card, where nesting labels is invalid HTML),
  # ported from shadcn/ui's FieldTitle. See field.rb.
  class FieldTitle < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-field-title" }, @attrs), &)
    end
  end
end
