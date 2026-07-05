# frozen_string_literal: true

module Docs
  module Examples
    module Slider
      class Vertical < Phlex::HTML
        def view_template
          render PhlexKit::Slider.new(name: "sl-vertical", value: 50, class: "vertical")
        end
      end
    end
  end
end
