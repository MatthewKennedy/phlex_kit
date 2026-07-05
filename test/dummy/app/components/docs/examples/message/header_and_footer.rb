# frozen_string_literal: true

module Docs
  module Examples
    module Message
      class HeaderAndFooter < Phlex::HTML
        def view_template
          div(class: "stack w-sm", style: "gap: 2rem; padding: 2rem 0;") do
            render PhlexKit::Message.new do
              render PhlexKit::MessageContent.new do
                render PhlexKit::MessageHeader.new { "Olivia" }
                render PhlexKit::Bubble.new(variant: :muted) do
                  render PhlexKit::BubbleContent.new { "I already checked the logs." }
                end
              end
            end
            render PhlexKit::Message.new(align: :end) do
              render PhlexKit::MessageContent.new do
                render PhlexKit::Bubble.new do
                  render PhlexKit::BubbleContent.new { "Send the report to the team. Ping @shadcn if you need help." }
                end
                render PhlexKit::MessageFooter.new do
                  div do
                    plain "Read "
                    span(style: "font-weight: 400") { "Yesterday" }
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
