# frozen_string_literal: true

module Docs
  module Examples
    module Field
      class WithInput < Phlex::HTML
        def view_template
          render PhlexKit::FieldSet.new(class: "w-sm") do
            render PhlexKit::FieldGroup.new do
              render PhlexKit::Field.new do
                render PhlexKit::FieldLabel.new(for: "fld-username") { "Username" }
                render PhlexKit::Input.new(id: "fld-username", placeholder: "Max Leiter")
                render PhlexKit::FieldDescription.new { "Choose a unique username for your account." }
              end
              render PhlexKit::Field.new do
                render PhlexKit::FieldLabel.new(for: "fld-password") { "Password" }
                render PhlexKit::FieldDescription.new { "Must be at least 8 characters long." }
                render PhlexKit::Input.new(id: "fld-password", type: :password, placeholder: "••••••••")
              end
            end
          end
        end
      end
    end
  end
end
