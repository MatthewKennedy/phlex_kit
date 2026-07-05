# frozen_string_literal: true

module Docs
  module Examples
    module Bubble
      class Alignment < Phlex::HTML
        def view_template
          div(class: "stack w-sm", style: "gap: 2rem; padding: 3rem 0;") do
            render PhlexKit::Bubble.new(variant: :muted) do
              render PhlexKit::BubbleContent.new { "This bubble is aligned to the start. This is the default alignment." }
            end
            render PhlexKit::Bubble.new(align: :end) do
              render PhlexKit::BubbleContent.new { "This bubble is aligned to the end. Use this for user messages." }
            end
          end
        end
      end
    end
  end
end
