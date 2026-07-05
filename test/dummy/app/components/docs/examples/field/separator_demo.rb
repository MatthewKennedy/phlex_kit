# frozen_string_literal: true

module Docs
  module Examples
    module Field
      class SeparatorDemo < Phlex::HTML
        def view_template
          render PhlexKit::FieldGroup.new(class: "w-sm") do
            render PhlexKit::Field.new do
              render PhlexKit::FieldLabel.new(for: "fld-sep-email") { "Email" }
              render PhlexKit::Input.new(id: "fld-sep-email", type: :email, placeholder: "m@example.com")
            end
            render PhlexKit::FieldSeparator.new { "Or continue with" }
            render PhlexKit::Button.new(variant: :outline, style: "width: 100%") { "Login with Google" }
          end
        end
      end
    end
  end
end
