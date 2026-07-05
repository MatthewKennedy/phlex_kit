# frozen_string_literal: true

module Docs
  module Examples
    module Bubble
      class Group < Phlex::HTML
        def view_template
          div(class: "stack w-sm", style: "gap: 2rem; padding: 3rem 0;") do
            render PhlexKit::Bubble.new(variant: :muted) do
              render PhlexKit::BubbleContent.new { "Can you tell me what's the issue?" }
            end
            render PhlexKit::BubbleGroup.new do
              render PhlexKit::Bubble.new(align: :end) do
                render PhlexKit::BubbleContent.new { "You tell me!" }
              end
              render PhlexKit::Bubble.new(align: :end) do
                render PhlexKit::BubbleContent.new { "It worked yesterday. You broke it!" }
              end
              render PhlexKit::Bubble.new(align: :end) do
                render PhlexKit::BubbleContent.new { "Find the bug and fix it." }
                render PhlexKit::BubbleReactions.new(align: :start, aria: { label: "Reactions: eyes" }) do
                  span { "👀" }
                end
              end
            end
            render PhlexKit::Bubble.new(variant: :muted) do
              render PhlexKit::BubbleContent.new { "Want me to diff yesterday's you against today's you? It's a bit embarrassing." }
            end
          end
        end
      end
    end
  end
end
