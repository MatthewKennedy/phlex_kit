module PhlexKit
  # <label> for a Field's control, ported from shadcn/ui's FieldLabel (their
  # Label + field styling — ours composes .pk-label the same way). Wrap a
  # whole Field in it for the choice-card recipe: the label grows a border
  # and highlights while its control is checked. See field.rb.
  class FieldLabel < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      label(**mix({ class: "pk-label pk-field-label", data: { slot: "field-label" } }, @attrs), &)
    end
  end
end
