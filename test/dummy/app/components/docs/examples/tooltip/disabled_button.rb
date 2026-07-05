# frozen_string_literal: true

module Docs
  module Examples
    module Tooltip
      class DisabledButton < Phlex::HTML
        def view_template
          # Wrap the disabled button so the tooltip still gets hover events.
          render PhlexKit::Tooltip.new do
            render PhlexKit::TooltipTrigger.new do
              span(style: "display: inline-block") do
                render PhlexKit::Button.new(variant: :outline, disabled: true) { "Disabled" }
              end
            end
            render PhlexKit::TooltipContent.new { "This feature is currently unavailable" }
          end
        end
      end
    end
  end
end
