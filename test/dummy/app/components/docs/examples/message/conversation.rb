# frozen_string_literal: true

module Docs
  module Examples
    module Message
      class Conversation < Phlex::HTML
        def view_template
          div(class: "stack w-lg") do
            render PhlexKit::MessageGroup.new do
              render PhlexKit::Message.new do
                render PhlexKit::MessageAvatar.new do
                  render PhlexKit::Avatar.new(size: :sm) { render PhlexKit::AvatarFallback.new { "A" } }
                end
                render PhlexKit::MessageContent.new do
                  render PhlexKit::MessageHeader.new { "Alice" }
                  render PhlexKit::BubbleGroup.new do
                    render PhlexKit::Bubble.new(variant: :secondary) do
                      render PhlexKit::BubbleContent.new { "Hey — did the release ship?" }
                    end
                  end
                end
              end
              render PhlexKit::Message.new(align: :end) do
                render PhlexKit::MessageContent.new do
                  render PhlexKit::BubbleGroup.new do
                    render PhlexKit::Bubble.new(align: :end) do
                      render PhlexKit::BubbleContent.new { "v0.2.1 is live ✅" }
                    end
                  end
                  render PhlexKit::MessageFooter.new { "Just now" }
                end
              end
            end
          end
        end
      end
    end
  end
end
