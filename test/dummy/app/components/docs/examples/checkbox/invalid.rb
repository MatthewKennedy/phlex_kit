# frozen_string_literal: true

module Docs
  module Examples
    module Checkbox
      class Invalid < Phlex::HTML
        def view_template
          div(class: "pk-checkbox-row") do
            render PhlexKit::Checkbox.new(id: "terms-checkbox-invalid", name: "terms-checkbox-invalid", aria: { invalid: "true" })
            render PhlexKit::Label.new(for: "terms-checkbox-invalid") { "Accept terms and conditions" }
          end
        end
      end
    end
  end
end
