# frozen_string_literal: true

module Docs
  module Examples
    module Slider
      class Disabled < Phlex::HTML
        def view_template
          div(class: "w-sm") do
            render PhlexKit::Slider.new(name: "sl-disabled", value: 50, disabled: true)
          end
        end
      end
    end
  end
end
