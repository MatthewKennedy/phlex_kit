# frozen_string_literal: true

module Docs
  module Examples
    module MessageScroller
      class OpeningPosition < Phlex::HTML
        def view_template
          div(class: "row", style: "align-items: flex-start; gap: 1.5rem; width: 100%;") do
            [ [ "end", "Opens at the newest message (default)" ], [ "start", "Opens at the oldest message" ] ].each do |position, caption|
              div(class: "stack", style: "flex: 1; gap: .5rem;") do
                div(style: "height: 200px") do
                  render PhlexKit::MessageScroller.new(data: { phlex_kit__message_scroller_default_position_value: position }) do
                    div(style: "height: 100%; overflow-y: auto;", data: { phlex_kit__message_scroller_target: "viewport" }) do
                      div(class: "stack", style: "padding: .25rem", data: { phlex_kit__message_scroller_target: "content" }) do
                        10.times do |i|
                          render PhlexKit::Message.new(align: i.even? ? :start : :end) do
                            render PhlexKit::MessageContent.new do
                              render PhlexKit::Bubble.new(align: i.even? ? :start : :end, variant: i.even? ? :muted : :default) do
                                render PhlexKit::BubbleContent.new { "Message #{i + 1}" }
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
                p(style: "margin: 0; font-size: .75rem; color: var(--pk-muted); text-align: center;") { caption }
              end
            end
          end
        end
      end
    end
  end
end
