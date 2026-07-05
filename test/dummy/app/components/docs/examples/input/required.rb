# frozen_string_literal: true

module Docs
  module Examples
    module Input
      class Required < Phlex::HTML
        def view_template
          render PhlexKit::Field.new(class: "w-sm") do
            render PhlexKit::FieldLabel.new(for: "input-required") do
              plain "Required Field "
              span(style: "color: var(--pk-red)") { "*" }
            end
            render PhlexKit::Input.new(id: "input-required", placeholder: "This field is required", required: true)
            render PhlexKit::FieldDescription.new { "This field must be filled out." }
          end
        end
      end
    end
  end
end
