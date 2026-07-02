module PhlexKit
  # Form field group, ported from ruby_ui's RubyUI::FormField: a vertical stack
  # grouping a FormFieldLabel + a control (PhlexKit::Input / Textarea / NativeSelect /
  # Checkbox / RadioButton …) + an optional FormFieldHint / FormFieldError.
  # Carries the phlex-kit--form-field controller for live validation: the kit's
  # controls register as its input target, and once the browser first flags the
  # control invalid (a submit attempt) — or the error renders with server
  # content — the FormFieldError live-updates as the user types, with
  # per-constraint messages via data-* on the control (data-value-missing,
  # data-type-mismatch, data-too-short, …). Compose inside PhlexKit::Form (form.rb).
  #
  # This replaces the legacy `.field` wrapper in converted views — and crucially
  # does NOT carry `.field`'s descendant `input/select/textarea` styling (whose
  # specificity would otherwise override `.pk-input` &c.), so the kit's controls
  # render with their own look. Multi-part, like PhlexKit::Card:
  #
  #   render PhlexKit::FormField.new do
  #     render PhlexKit::FormFieldLabel.new(for: "user_email") { "Email" }
  #     render PhlexKit::Input.new(type: :email, id: "user_email", name: "user[email]")
  #     render PhlexKit::FormFieldError.new { "is invalid" }
  #   end
  class FormField < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({ class: "pk-form-field", data: { controller: "phlex-kit--form-field" } }, @attrs), &block)
    end
  end
end
