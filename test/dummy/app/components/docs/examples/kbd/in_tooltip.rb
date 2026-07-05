# frozen_string_literal: true

module Docs
  module Examples
    module Kbd
      class InTooltip < Phlex::HTML
        def view_template
          render PhlexKit::ButtonGroup.new do
            render PhlexKit::Tooltip.new do
              render PhlexKit::TooltipTrigger.new do
                render PhlexKit::Button.new(variant: :outline) { "Save" }
              end
              render PhlexKit::TooltipContent.new do
                plain "Save Changes "
                render PhlexKit::Kbd.new { "S" }
              end
            end
            render PhlexKit::Tooltip.new do
              render PhlexKit::TooltipTrigger.new do
                render PhlexKit::Button.new(variant: :outline) { "Print" }
              end
              render PhlexKit::TooltipContent.new do
                plain "Print Document "
                render PhlexKit::KbdGroup.new do
                  render PhlexKit::Kbd.new { "Ctrl" }
                  render PhlexKit::Kbd.new { "P" }
                end
              end
            end
          end
        end
      end
    end
  end
end
