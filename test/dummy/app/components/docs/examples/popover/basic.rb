# frozen_string_literal: true

module Docs
  module Examples
    module Popover
      class Basic < Phlex::HTML
        def view_template
          render PhlexKit::Popover.new do
            render PhlexKit::PopoverTrigger.new do
              render PhlexKit::Button.new(variant: :outline) { "Open Popover" }
            end
            render PhlexKit::PopoverContent.new do
              render PhlexKit::PopoverHeader.new do
                render PhlexKit::PopoverTitle.new { "Dimensions" }
                render PhlexKit::PopoverDescription.new { "Set the dimensions for the layer." }
              end
            end
          end
        end
      end
    end
  end
end
