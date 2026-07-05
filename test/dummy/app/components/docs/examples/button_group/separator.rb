# frozen_string_literal: true

module Docs
  module Examples
    module ButtonGroup
      class Separator < Phlex::HTML
        def view_template
          render PhlexKit::ButtonGroup.new do
            render PhlexKit::Button.new(variant: :secondary, size: :sm) { "Copy" }
            render PhlexKit::ButtonGroupSeparator.new
            render PhlexKit::Button.new(variant: :secondary, size: :sm) { "Paste" }
          end
        end
      end
    end
  end
end
