# frozen_string_literal: true

module Docs
  module Examples
    module Skeleton
      class Default < Phlex::HTML
        def view_template
          div(class: "row", style: "gap: 1rem") do
            render PhlexKit::Skeleton.new(style: "height: 3rem; width: 3rem; border-radius: 999px;")
            div(class: "stack", style: "gap: .5rem") do
              render PhlexKit::Skeleton.new(style: "height: 1rem; width: 250px")
              render PhlexKit::Skeleton.new(style: "height: 1rem; width: 200px")
            end
          end
        end
      end
    end
  end
end
