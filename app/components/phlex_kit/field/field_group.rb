module PhlexKit
  # Column of Fields with the canonical rhythm, ported from shadcn/ui's
  # FieldGroup. Also the CONTAINER for responsive fields — a Field with
  # orientation: :responsive goes horizontal when this group is ≥28rem wide.
  # See field.rb.
  class FieldGroup < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-field-group", data: { slot: "field-group" } }, @attrs), &)
    end
  end
end
