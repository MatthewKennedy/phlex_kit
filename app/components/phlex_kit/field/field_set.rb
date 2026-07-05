module PhlexKit
  # Semantic <fieldset> grouping several Fields under a FieldLegend, ported
  # from shadcn/ui's FieldSet. See field.rb.
  class FieldSet < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      fieldset(**mix({ class: "pk-field-set" }, @attrs), &)
    end
  end
end
