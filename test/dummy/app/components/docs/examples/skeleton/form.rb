# frozen_string_literal: true

module Docs
  module Examples
    module Skeleton
      class Form < Phlex::HTML
        def view_template
          div(class: "stack w-sm", style: "gap: 1rem") do
            div(class: "stack", style: "gap: .5rem") do
              render PhlexKit::Skeleton.new(style: "height: .875rem; width: 5rem")
              render PhlexKit::Skeleton.new(style: "height: 2rem; width: 100%")
            end
            div(class: "stack", style: "gap: .5rem") do
              render PhlexKit::Skeleton.new(style: "height: .875rem; width: 6rem")
              render PhlexKit::Skeleton.new(style: "height: 2rem; width: 100%")
            end
            render PhlexKit::Skeleton.new(style: "height: 2rem; width: 6rem")
          end
        end
      end
    end
  end
end
