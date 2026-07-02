module PhlexKit
  # Validation error text for a PhlexKit::FormField, styled with the destructive token
  # and hidden when empty. Render it empty for live client-side messages (the
  # phlex-kit--form-field controller fills it once the control goes invalid), or
  # with server-rendered model errors — non-empty content arms validation on
  # connect. See form_field.rb.
  class FormFieldError < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      p(**mix({
        class: "pk-form-field-error",
        data: { phlex_kit__form_field_target: "error" }
      }, @attrs), &block)
    end
  end
end
