# frozen_string_literal: true

module Docs
  module Examples
    module Bubble
      class ShowMore < Phlex::HTML
        def view_template
          div(class: "stack w-sm", style: "gap: 2rem; padding: 3rem 0;") do
            render PhlexKit::Bubble.new(variant: :muted) do
              render PhlexKit::BubbleContent.new { "How can I help you today?" }
            end
            render PhlexKit::Bubble.new(variant: :muted, align: :end) do
              render PhlexKit::BubbleContent.new do
                render PhlexKit::Collapsible.new do
                  p { "The accessibility review found two focus states that were visually too subtle in dark mode. I checked the dialog, menu, and drawer paths because each one renders focusable controls inside a layered surface…" }
                  render PhlexKit::CollapsibleContent.new do
                    p { "The dialog and drawer are fine. The menu needs the hover and focus tokens split so keyboard focus stays visible when the pointer is not involved." }
                    p { "I also recommend keeping the change in the style file instead of the primitive so the other themes can choose their own focus treatment later." }
                  end
                  render PhlexKit::CollapsibleTrigger.new do
                    render PhlexKit::Button.new(variant: :link, size: :sm) { "Show more" }
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
