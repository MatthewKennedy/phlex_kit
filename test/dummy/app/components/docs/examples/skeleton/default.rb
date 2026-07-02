# frozen_string_literal: true

module Docs
  module Examples
    module Skeleton
      class Default < Phlex::HTML
        def view_template
          div(class: "row") do
            render PhlexKit::Skeleton.new(style: "width:3rem;height:3rem;border-radius:9999px")
            div(class: "stack", style: "gap:.5rem") do
              render PhlexKit::Skeleton.new(style: "width:250px;height:1rem")
              render PhlexKit::Skeleton.new(style: "width:200px;height:1rem")
            end
          end
        end
      end
    end
  end
end
