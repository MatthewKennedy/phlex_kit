module PhlexKit
  # Muted helper text under a PhlexKit::FormField control. Hidden when empty.
  # See form_field.rb.
  class FormFieldHint < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      p(**mix({ class: "pk-form-field-hint" }, @attrs), &block)
    end
  end
end
