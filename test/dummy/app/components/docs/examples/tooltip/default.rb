# frozen_string_literal: true

module Docs
  module Examples
    module Tooltip
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::Tooltip.new do
            render PhlexKit::TooltipTrigger.new do
              render PhlexKit::Button.new(variant: :outline) { "Hover" }
            end
            render PhlexKit::TooltipContent.new { "Add to library" }
          end
        end
      end
    end
  end
end
