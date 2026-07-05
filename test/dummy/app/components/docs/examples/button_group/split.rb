# frozen_string_literal: true

module Docs
  module Examples
    module ButtonGroup
      class Split < Phlex::HTML
        def view_template
          render PhlexKit::ButtonGroup.new do
            render PhlexKit::Button.new(variant: :secondary) { "Button" }
            render PhlexKit::ButtonGroupSeparator.new
            render PhlexKit::Button.new(variant: :secondary, icon: true) do
              render PhlexKit::Icon.new(:plus, size: nil)
            end
          end
        end
      end
    end
  end
end
