# frozen_string_literal: true

module Docs
  module Examples
    module ButtonGroup
      class Size < Phlex::HTML
        def view_template
          div(class: "stack", style: "align-items: flex-start; gap: 2rem;") do
            [ :sm, :md, :lg ].each do |size|
              render PhlexKit::ButtonGroup.new do
                render PhlexKit::Button.new(variant: :outline, size: size) do
                  plain({ sm: "Small", md: "Default", lg: "Large" }.fetch(size))
                end
                render PhlexKit::Button.new(variant: :outline, size: size) { "Button" }
                render PhlexKit::Button.new(variant: :outline, size: size) { "Group" }
                render PhlexKit::Button.new(variant: :outline, size: size, icon: true) do
                  render PhlexKit::Icon.new(:plus, size: nil)
                end
              end
            end
          end
        end
      end
    end
  end
end
