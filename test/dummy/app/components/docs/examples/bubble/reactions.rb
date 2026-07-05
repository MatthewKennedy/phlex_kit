# frozen_string_literal: true

module Docs
  module Examples
    module Bubble
      class Reactions < Phlex::HTML
        def view_template
          div(class: "stack w-sm", style: "gap: 3rem; padding: 3rem 0;") do
            render PhlexKit::Bubble.new(variant: :muted, align: :end) do
              render PhlexKit::BubbleContent.new { "I don't need tests, I know my code works." }
              render PhlexKit::BubbleReactions.new(align: :start, role: "img", aria: { label: "Reactions: thumbs up, surprised" }) do
                span { "👍" }
                span { "😮" }
              end
            end
            render PhlexKit::Bubble.new(variant: :muted) do
              render PhlexKit::BubbleContent.new { "Bold. Fine I'll add some tests. I'll let you know when they're done." }
              render PhlexKit::BubbleReactions.new(role: "img", aria: { label: "Reactions: eyes, rocket, and 2 more" }) do
                span { "👀" }
                span { "🚀" }
                span { "+2" }
              end
            end
            render PhlexKit::Bubble.new(align: :end) do
              render PhlexKit::BubbleContent.new { "Tests passed on the first try. All 142 of them. Looking good!" }
              render PhlexKit::BubbleReactions.new(side: :top, align: :start, role: "img", aria: { label: "Reactions: party popper, clapping hands" }) do
                span { "🎉" }
                span { "👏" }
              end
            end
            render PhlexKit::Bubble.new(variant: :destructive) do
              render PhlexKit::BubbleContent.new { "Are you sure I can run this command?" }
              render PhlexKit::BubbleReactions.new do
                render PhlexKit::Button.new(variant: :ghost, size: :xs) { "Yes, run it" }
              end
            end
          end
        end
      end
    end
  end
end
