# frozen_string_literal: true

module Docs
  module Examples
    module Button
      class Size < Phlex::HTML
        def view_template
          div(class: "row", style: "align-items: flex-start; gap: 2rem;") do
            [ :xs, :sm, :md, :lg ].each do |size|
              div(class: "row") do
                render PhlexKit::Button.new(size: size, variant: :outline) do
                  plain({ xs: "Extra Small", sm: "Small", md: "Default", lg: "Large" }.fetch(size))
                end
                render PhlexKit::Button.new(size: size, variant: :outline, icon: true, aria: { label: "Submit" }) do
                  render PhlexKit::Icon.new(:arrow_right, size: nil)
                end
              end
            end
          end
        end
      end
    end
  end
end
