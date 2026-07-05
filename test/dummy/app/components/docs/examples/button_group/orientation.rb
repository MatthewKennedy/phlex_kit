# frozen_string_literal: true

module Docs
  module Examples
    module ButtonGroup
      class Orientation < Phlex::HTML
        def view_template
          render PhlexKit::ButtonGroup.new(orientation: :vertical, aria: { label: "Media controls" }) do
            render PhlexKit::Button.new(variant: :outline, icon: true) do
              render PhlexKit::Icon.new(:plus, size: nil)
            end
            render PhlexKit::Button.new(variant: :outline, icon: true) do
              render PhlexKit::Icon.new(:minus, size: nil)
            end
          end
        end
      end
    end
  end
end
