# frozen_string_literal: true

module Docs
  module Examples
    module HoverCard
      class Sides < Phlex::HTML
        def view_template
          div(class: "row", style: "justify-content: center") do
            [ :left, :top, :bottom, :right ].each do |side|
              render PhlexKit::HoverCard.new do
                render PhlexKit::HoverCardTrigger.new do
                  render PhlexKit::Button.new(variant: :outline) { side.to_s.capitalize }
                end
                render PhlexKit::HoverCardContent.new(side: side) do
                  div(style: "display: flex; flex-direction: column; gap: .25rem;") do
                    h4(style: "margin: 0; font-weight: 500;") { "Hover Card" }
                    p(style: "margin: 0") { "This hover card appears on the #{side} side of the trigger." }
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
