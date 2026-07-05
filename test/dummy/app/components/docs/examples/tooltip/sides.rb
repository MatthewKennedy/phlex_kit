# frozen_string_literal: true

module Docs
  module Examples
    module Tooltip
      class Sides < Phlex::HTML
        def view_template
          div(class: "row") do
            [ :left, :top, :bottom, :right ].each do |side|
              render PhlexKit::Tooltip.new do
                render PhlexKit::TooltipTrigger.new do
                  render PhlexKit::Button.new(variant: :outline) { side.to_s.capitalize }
                end
                render PhlexKit::TooltipContent.new(side: side) { "Add to library" }
              end
            end
          end
        end
      end
    end
  end
end
