# frozen_string_literal: true

module Docs
  module Examples
    module Slider
      class Default < Phlex::HTML
        def view_template
          div(class: "stack w-md") do
            render PhlexKit::Slider.new(name: "volume", value: 50)
            render PhlexKit::Slider.new(name: "step", min: 0, max: 100, step: 10, value: 30)
            render PhlexKit::Slider.new(name: "off", value: 25, disabled: true)
          end
        end
      end
    end
  end
end
