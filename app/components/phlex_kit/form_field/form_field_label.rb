module PhlexKit
  # Label for a PhlexKit::FormField control. Pass `for:` to bind it to the control's id
  # (e.g. `for: f.field_id(:email)`). Hidden when empty. See form_field.rb.
  class FormFieldLabel < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      label(**mix({ class: "pk-form-field-label" }, @attrs), &block)
    end
  end
end
