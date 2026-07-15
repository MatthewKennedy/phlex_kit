# frozen_string_literal: true

module Docs
  module Examples
    module Form
      # A FormFieldError rendered WITH content (a server-side model error):
      # the form-field controller arms validation on connect and wires
      # aria-invalid / aria-describedby onto the control immediately, without
      # waiting for the first input/change.
      class ServerError < Phlex::HTML
        def view_template
          render PhlexKit::Form.new(action: "#", method: "get", class: "w-md") do
            render PhlexKit::FormField.new do
              render PhlexKit::FormFieldLabel.new(for: "form-handle") { "Handle" }
              render PhlexKit::Input.new(
                id: "form-handle", name: "handle", required: true, minlength: 3,
                value: "pk", placeholder: "phlex",
                data: { value_missing: "Handle is required.", too_short: "At least 3 characters." }
              )
              render PhlexKit::FormFieldError.new { "Handle is already taken." }
            end
            div(class: "pk-form-actions") do
              render PhlexKit::Button.new(type: :submit) { "Save" }
            end
          end
        end
      end
    end
  end
end
