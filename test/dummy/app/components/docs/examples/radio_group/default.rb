# frozen_string_literal: true

module Docs
  module Examples
    module RadioGroup
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::RadioGroup.new do
            render PhlexKit::Label.new do
              render PhlexKit::RadioButton.new(name: "density", value: "default", checked: true)
              plain "Default"
            end
            render PhlexKit::Label.new do
              render PhlexKit::RadioButton.new(name: "density", value: "comfortable")
              plain "Comfortable"
            end
            render PhlexKit::Label.new do
              render PhlexKit::RadioButton.new(name: "density", value: "compact")
              plain "Compact"
            end
          end
        end
      end
    end
  end
end
