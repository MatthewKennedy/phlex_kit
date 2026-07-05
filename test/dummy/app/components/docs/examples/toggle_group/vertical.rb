# frozen_string_literal: true

module Docs
  module Examples
    module ToggleGroup
      class Vertical < Phlex::HTML
        def view_template
          render PhlexKit::ToggleGroup.new(type: :single, value: "top", variant: :outline, orientation: :vertical) do |group|
            group.ToggleGroupItem(value: "top") { "Top" }
            group.ToggleGroupItem(value: "middle") { "Middle" }
            group.ToggleGroupItem(value: "bottom") { "Bottom" }
          end
        end
      end
    end
  end
end
