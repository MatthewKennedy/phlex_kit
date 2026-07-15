module PhlexKit
  # Muted helper text under a PhlexKit::FormField control. Hidden when empty.
  # See form_field.rb.
  class FormFieldHint < BaseComponent
    # A default id (like FormFieldError) so the controller can wire the hint
    # into every control's aria-describedby — without it SR users never heard
    # the hint text. id: is a named kwarg to avoid mix id-fusion.
    def initialize(id: nil, **attrs)
      @id = id || "pk-form-field-hint-#{SecureRandom.hex(4)}"
      @attrs = attrs
    end

    def view_template(&block)
      p(**mix({ id: @id, class: "pk-form-field-hint", data: { phlex_kit__form_field_target: "hint" } }, @attrs), &block)
    end
  end
end
