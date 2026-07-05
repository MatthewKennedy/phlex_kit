# frozen_string_literal: true

module Docs
  module Examples
    module Bubble
      class Tooltip < Phlex::HTML
        def view_template
          div(class: "stack w-sm", style: "gap: 1rem; padding: 3rem 0;") do
            render PhlexKit::Bubble.new(variant: :secondary) do
              render PhlexKit::BubbleContent.new { "Did you remove the stale route?" }
            end
            render PhlexKit::Bubble.new(align: :end) do
              render PhlexKit::BubbleContent.new { "Yes, removed it from the registry." }
              render PhlexKit::BubbleReactions.new do
                render PhlexKit::Tooltip.new do
                  render PhlexKit::TooltipTrigger.new do
                    render PhlexKit::Button.new(variant: :ghost, size: :sm, icon: true) do
                      render PhlexKit::Icon.new(:check)
                    end
                  end
                  render PhlexKit::TooltipContent.new { "Read on Jan 5, 2026 at 4:32 PM" }
                end
              end
            end
          end
        end
      end
    end
  end
end
