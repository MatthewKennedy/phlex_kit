# frozen_string_literal: true

module Docs
  module Examples
    module Checkbox
      class Description < Phlex::HTML
        def view_template
          render PhlexKit::Field.new(orientation: :horizontal, class: "w-sm") do
            render PhlexKit::Checkbox.new(id: "terms-checkbox-desc", name: "terms-checkbox-desc", checked: true)
            render PhlexKit::FieldContent.new do
              render PhlexKit::FieldLabel.new(for: "terms-checkbox-desc") { "Accept terms and conditions" }
              render PhlexKit::FieldDescription.new { "By clicking this checkbox, you agree to the terms and conditions." }
            end
          end
        end
      end
    end
  end
end
