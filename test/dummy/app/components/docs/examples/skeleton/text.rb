# frozen_string_literal: true

module Docs
  module Examples
    module Skeleton
      class Text < Phlex::HTML
        def view_template
          div(class: "stack w-sm", style: "gap: .5rem") do
            render PhlexKit::Skeleton.new(style: "height: 1rem; width: 100%")
            render PhlexKit::Skeleton.new(style: "height: 1rem; width: 100%")
            render PhlexKit::Skeleton.new(style: "height: 1rem; width: 75%")
          end
        end
      end
    end
  end
end
