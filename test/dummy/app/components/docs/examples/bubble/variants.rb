# frozen_string_literal: true

module Docs
  module Examples
    module Bubble
      class Variants < Phlex::HTML
        def view_template
          div(class: "stack w-sm", style: "gap: 3rem; padding: 3rem 0;") do
            render PhlexKit::Bubble.new do
              render PhlexKit::BubbleContent.new { "This is the default primary bubble." }
            end
            render PhlexKit::Bubble.new(variant: :secondary, align: :end) do
              render PhlexKit::BubbleContent.new { "This is the secondary variant." }
            end
            render PhlexKit::Bubble.new(variant: :muted) do
              render PhlexKit::BubbleContent.new { "This one is muted. It uses a lower emphasis color for the chat bubble." }
              render PhlexKit::BubbleReactions.new(role: "img", aria: { label: "Reaction: thumbs up" }) do
                span { "👍" }
              end
            end
            render PhlexKit::Bubble.new(variant: :tinted, align: :end) do
              render PhlexKit::BubbleContent.new { "This one is tinted. The tint is a softer color derived from the primary color." }
            end
            render PhlexKit::Bubble.new(variant: :outline) do
              render PhlexKit::BubbleContent.new { "We can also use an outlined variant." }
            end
            render PhlexKit::Bubble.new(variant: :destructive, align: :end) do
              render PhlexKit::BubbleContent.new { "Or a destructive variant with a reaction." }
              render PhlexKit::BubbleReactions.new(role: "img", aria: { label: "Reaction: fire" }) do
                span { "🔥" }
              end
            end
            render PhlexKit::Bubble.new(variant: :ghost) do
              render PhlexKit::BubbleContent.new do
                p do
                  plain "Ghost bubbles work for assistant text, "
                  b { "markdown" }
                  plain ", and other content that should not be framed."
                end
                p { "This is perfect for assistant messages that should not have a frame and can take the full width of the container." }
              end
            end
          end
        end
      end
    end
  end
end
