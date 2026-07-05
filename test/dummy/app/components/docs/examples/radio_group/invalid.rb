# frozen_string_literal: true

module Docs
  module Examples
    module RadioGroup
      class Invalid < Phlex::HTML
        def view_template
          render PhlexKit::RadioGroup.new do
            render PhlexKit::Label.new do
              render PhlexKit::RadioButton.new(name: "rg-invalid", value: "default", aria: { invalid: "true" })
              plain "Default"
            end
            render PhlexKit::Label.new do
              render PhlexKit::RadioButton.new(name: "rg-invalid", value: "comfortable", aria: { invalid: "true" })
              plain "Comfortable"
            end
          end
        end
      end
    end
  end
end
