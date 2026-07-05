# frozen_string_literal: true

module Docs
  module Examples
    module Skeleton
      class Card < Phlex::HTML
        def view_template
          render PhlexKit::Card.new(style: "width: 100%; max-width: 20rem;") do
            render PhlexKit::CardHeader.new do
              render PhlexKit::Skeleton.new(style: "height: 1rem; width: 66%")
              render PhlexKit::Skeleton.new(style: "height: 1rem; width: 50%")
            end
            render PhlexKit::CardContent.new do
              render PhlexKit::Skeleton.new(style: "aspect-ratio: 16/9; width: 100%")
            end
          end
        end
      end
    end
  end
end
