# frozen_string_literal: true

module Docs
  module Examples
    module Field
      class WithError < Phlex::HTML
        def view_template
          render PhlexKit::FieldGroup.new(class: "w-sm") do
            render PhlexKit::Field.new(invalid: true) do
              render PhlexKit::FieldLabel.new(for: "fld-err-email") { "Email" }
              render PhlexKit::Input.new(id: "fld-err-email", type: :email, value: "max@", aria: { invalid: "true" })
              render PhlexKit::FieldError.new(errors: [ "Enter a valid email address." ])
            end
            render PhlexKit::Field.new(invalid: true) do
              render PhlexKit::FieldLabel.new(for: "fld-err-pass") { "Password" }
              render PhlexKit::Input.new(id: "fld-err-pass", type: :password, aria: { invalid: "true" })
              render PhlexKit::FieldError.new(errors: [ "Must be at least 8 characters.", "Must include a number." ])
            end
          end
        end
      end
    end
  end
end
