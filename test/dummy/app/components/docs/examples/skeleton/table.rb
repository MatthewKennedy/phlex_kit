# frozen_string_literal: true

module Docs
  module Examples
    module Skeleton
      class Table < Phlex::HTML
        def view_template
          div(class: "stack w-md", style: "gap: .75rem") do
            render PhlexKit::Skeleton.new(style: "height: 1.5rem; width: 100%")
            4.times do
              div(class: "row", style: "gap: 1rem") do
                render PhlexKit::Skeleton.new(style: "height: 1rem; flex: 2")
                render PhlexKit::Skeleton.new(style: "height: 1rem; flex: 3")
                render PhlexKit::Skeleton.new(style: "height: 1rem; flex: 1")
              end
            end
          end
        end
      end
    end
  end
end
