# frozen_string_literal: true

module Docs
  module Examples
    module Tooltip
      class WithKbd < Phlex::HTML
        def view_template
          render PhlexKit::Tooltip.new do
            render PhlexKit::TooltipTrigger.new do
              render PhlexKit::Button.new(variant: :outline, size: :sm, icon: true, aria: { label: "Save" }) do
                render PhlexKit::Icon.new(:download, size: nil)
              end
            end
            render PhlexKit::TooltipContent.new do
              plain "Save Changes "
              render PhlexKit::Kbd.new { "S" }
            end
          end
        end
      end
    end
  end
end
