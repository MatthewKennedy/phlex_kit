# frozen_string_literal: true

module Docs
  module Examples
    module MessageScroller
      class Default < Phlex::HTML
        def view_template
          div(class: "w-lg", style: "height: 220px") do
            render PhlexKit::MessageScroller.new do
              div(style: "height:100%;overflow-y:auto", data: { phlex_kit__message_scroller_target: "viewport" }) do
                div(class: "stack", style: "padding:.25rem", data: { phlex_kit__message_scroller_target: "content" }) do
                  12.times do |i|
                    render PhlexKit::Message.new(align: i.even? ? :start : :end) do
                      render PhlexKit::MessageContent.new do
                        render PhlexKit::Bubble.new(align: i.even? ? :start : :end, variant: i.even? ? :secondary : :default) do
                          render PhlexKit::BubbleContent.new { "Message #{i + 1}" }
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
    end
  end
end
