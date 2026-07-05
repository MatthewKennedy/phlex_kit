# frozen_string_literal: true

module Docs
  module Examples
    module RadioGroup
      class Disabled < Phlex::HTML
        def view_template
          render PhlexKit::RadioGroup.new(style: "opacity: .6") do
            render PhlexKit::Label.new do
              render PhlexKit::RadioButton.new(name: "rg-disabled", value: "default", checked: true, disabled: true)
              plain "Default"
            end
            render PhlexKit::Label.new do
              render PhlexKit::RadioButton.new(name: "rg-disabled", value: "comfortable", disabled: true)
              plain "Comfortable"
            end
          end
        end
      end
    end
  end
end
