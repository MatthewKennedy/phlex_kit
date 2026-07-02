module PhlexKit
  # Form shell, ported from ruby_ui's RubyUI::Form. A plain <form> that stacks
  # PhlexKit::FormFields with rhythm (`.pk-form`, form.css — plus
  # `.pk-form-actions` for the submit/cancel row). Live validation lives on each
  # FormField (see form_field.rb), so this stays markup-only:
  #
  #   render PhlexKit::Form.new(action: "/reviews", method: "post") do
  #     render PhlexKit::FormField.new do
  #       render PhlexKit::FormFieldLabel.new(for: "email") { "Email" }
  #       render PhlexKit::Input.new(type: :email, id: "email", name: "email", required: true)
  #       render PhlexKit::FormFieldError.new
  #     end
  #     div(class: "pk-form-actions") { render PhlexKit::Button.new(type: :submit) { "Save" } }
  #   end
  #
  # With Rails form helpers, put the class on the builder instead:
  # `form_with(..., class: "pk-form")`.
  class Form < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      form(**mix({ class: "pk-form" }, @attrs), &)
    end
  end
end
