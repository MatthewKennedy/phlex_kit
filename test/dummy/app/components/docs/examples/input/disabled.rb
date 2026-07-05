# frozen_string_literal: true

module Docs
  module Examples
    module Input
      class Disabled < Phlex::HTML
        def view_template
          div(class: "w-sm") do
            render PhlexKit::FormField.new do
              render PhlexKit::FormFieldLabel.new(for: "input-demo-disabled") { "Email" }
              render PhlexKit::Input.new(id: "input-demo-disabled", type: :email, placeholder: "Email", disabled: true)
              render PhlexKit::FormFieldHint.new { "This field is currently disabled." }
            end
          end
        end
      end
    end
  end
end
