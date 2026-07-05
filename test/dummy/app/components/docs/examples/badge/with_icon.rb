# frozen_string_literal: true

module Docs
  module Examples
    module Badge
      class WithIcon < Phlex::HTML
        def view_template
          div(class: "row") do
            render PhlexKit::Badge.new(variant: :secondary) do
              render PhlexKit::Icon.new(:circle_check, size: nil, data: { icon: "inline-start" })
              plain "Verified"
            end
            render PhlexKit::Badge.new(variant: :outline) do
              plain "Bookmark"
              render PhlexKit::Icon.new(:bookmark, size: nil, data: { icon: "inline-end" })
            end
          end
        end
      end
    end
  end
end
