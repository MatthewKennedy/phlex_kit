# frozen_string_literal: true

module Docs
  module Examples
    module Input
      class Disabled < Phlex::HTML
        def view_template
          render PhlexKit::Field.new(disabled: true, class: "w-sm") do
            render PhlexKit::FieldLabel.new(for: "input-demo-disabled") { "Email" }
            render PhlexKit::Input.new(id: "input-demo-disabled", type: :email, placeholder: "Email", disabled: true)
            render PhlexKit::FieldDescription.new { "This field is currently disabled." }
          end
        end
      end
    end
  end
end
