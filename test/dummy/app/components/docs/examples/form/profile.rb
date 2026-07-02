# frozen_string_literal: true

module Docs
  module Examples
    module Form
      class Profile < Phlex::HTML
        def view_template
          render PhlexKit::Form.new(action: "#", method: "get", class: "w-md") do
            render PhlexKit::FormField.new do
              render PhlexKit::FormFieldLabel.new(for: "form-username") { "Username" }
              render PhlexKit::Input.new(
                id: "form-username", name: "username", required: true, minlength: 2,
                placeholder: "phlex",
                data: { value_missing: "Username is required.", too_short: "At least 2 characters." }
              )
              render PhlexKit::FormFieldHint.new { "This is your public display name." }
              render PhlexKit::FormFieldError.new
            end
            render PhlexKit::FormField.new do
              render PhlexKit::FormFieldLabel.new(for: "form-email") { "Email" }
              render PhlexKit::Input.new(
                type: :email, id: "form-email", name: "email", required: true,
                placeholder: "you@example.com",
                data: { value_missing: "Email is required.", type_mismatch: "That doesn't look like an email." }
              )
              render PhlexKit::FormFieldError.new
            end
            div(class: "pk-form-actions") do
              render PhlexKit::Button.new(type: :submit) { "Update profile" }
            end
          end
        end
      end
    end
  end
end
