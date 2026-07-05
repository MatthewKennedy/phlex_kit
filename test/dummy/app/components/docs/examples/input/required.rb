# frozen_string_literal: true

module Docs
  module Examples
    module Input
      class Required < Phlex::HTML
        def view_template
          div(class: "w-sm") do
            render PhlexKit::FormField.new do
              render PhlexKit::FormFieldLabel.new(for: "input-required") do
                plain "Required Field "
                span(style: "color: var(--pk-red)") { "*" }
              end
              render PhlexKit::Input.new(id: "input-required", placeholder: "This field is required", required: true)
              render PhlexKit::FormFieldHint.new { "This field must be filled out." }
            end
          end
        end
      end
    end
  end
end
