# frozen_string_literal: true

module Docs
  module Examples
    module Input
      class Types < Phlex::HTML
        def view_template
          div(class: "stack w-sm") do
            render PhlexKit::Input.new(type: :password, placeholder: "Password")
            render PhlexKit::Input.new(type: :number, placeholder: "Amount")
            render PhlexKit::Input.new(type: :file)
            render PhlexKit::Input.new(placeholder: "Disabled", disabled: true)
            render PhlexKit::Input.new(placeholder: "Invalid", "aria-invalid": "true")
          end
        end
      end
    end
  end
end
