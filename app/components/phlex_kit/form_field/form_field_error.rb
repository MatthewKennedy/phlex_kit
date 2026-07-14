module PhlexKit
  # Validation error text for a PhlexKit::FormField, styled with the destructive token
  # and hidden when empty. Render it empty for live client-side messages (the
  # phlex-kit--form-field controller fills it once the control goes invalid), or
  # with server-rendered model errors — non-empty content arms validation on
  # connect. See form_field.rb.
  class FormFieldError < BaseComponent
    def initialize(id: nil, **attrs)
      # A default id (like SelectContent / CommandList) so the controller can
      # always wire aria-describedby from the control to this message.
      @id = id || "pk-form-field-error-#{SecureRandom.hex(4)}"
      @attrs = attrs
    end

    def view_template(&block)
      # role="alert": the controller swaps this text live on invalid/input —
      # without a live region the announcement never reaches screen readers.
      p(**mix({
        id: @id,
        class: "pk-form-field-error",
        role: "alert",
        data: { phlex_kit__form_field_target: "error" }
      }, @attrs), &block)
    end
  end
end
