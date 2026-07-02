# frozen_string_literal: true

module Docs
  module Examples
    module ButtonGroup
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::ButtonGroup.new do
            render PhlexKit::Button.new(variant: :outline, size: :sm) { "Day" }
            render PhlexKit::Button.new(variant: :outline, size: :sm) { "Week" }
            render PhlexKit::Button.new(variant: :outline, size: :sm) { "Month" }
          end
        end
      end
    end
  end
end
