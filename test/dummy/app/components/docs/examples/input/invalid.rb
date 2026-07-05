# frozen_string_literal: true

module Docs
  module Examples
    module Input
      class Invalid < Phlex::HTML
        def view_template
          render PhlexKit::Field.new(invalid: true, class: "w-sm") do
            render PhlexKit::FieldLabel.new(for: "input-invalid") { "Invalid Input" }
            render PhlexKit::Input.new(id: "input-invalid", placeholder: "Error", aria: { invalid: "true" })
            render PhlexKit::FieldDescription.new { "This field contains validation errors." }
          end
        end
      end
    end
  end
end
