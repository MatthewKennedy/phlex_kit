# frozen_string_literal: true

module Docs
  module Examples
    module Input
      class Invalid < Phlex::HTML
        def view_template
          div(class: "w-sm") do
            render PhlexKit::FormField.new do
              render PhlexKit::FormFieldLabel.new(for: "input-invalid") { "Invalid Input" }
              render PhlexKit::Input.new(id: "input-invalid", placeholder: "Error", aria: { invalid: "true" })
              render PhlexKit::FormFieldHint.new { "This field contains validation errors." }
            end
          end
        end
      end
    end
  end
end
