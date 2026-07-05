# frozen_string_literal: true

module Docs
  module Examples
    module Bubble
      class LinksAndButtons < Phlex::HTML
        def view_template
          div(class: "stack w-sm", style: "gap: 2rem; padding: 3rem 0;") do
            render PhlexKit::Bubble.new(variant: :muted) do
              render PhlexKit::BubbleContent.new { "How can I help you today?" }
            end
            # BubbleContent as: :button (or :a + href:) makes the whole
            # bubble interactive — hover fill and focus ring included.
            render PhlexKit::BubbleGroup.new do
              render PhlexKit::Bubble.new(variant: :tinted, align: :end) do
                render PhlexKit::BubbleContent.new(as: :button, type: "button") { "I forgot my password" }
              end
              render PhlexKit::Bubble.new(variant: :tinted, align: :end) do
                render PhlexKit::BubbleContent.new(as: :button, type: "button") { "I need help with my subscription" }
              end
              render PhlexKit::Bubble.new(variant: :tinted, align: :end) do
                render PhlexKit::BubbleContent.new(as: :button, type: "button") { "Something else. Talk to a human." }
              end
            end
          end
        end
      end
    end
  end
end
