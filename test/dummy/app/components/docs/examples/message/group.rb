# frozen_string_literal: true

module Docs
  module Examples
    module Message
      class Group < Phlex::HTML
        def view_template
          div(class: "w-sm", style: "padding: 2rem 0;") do
            render PhlexKit::MessageGroup.new do
              render PhlexKit::Message.new do
                render PhlexKit::MessageAvatar.new
                render PhlexKit::MessageContent.new do
                  render PhlexKit::Bubble.new(variant: :muted) do
                    render PhlexKit::BubbleContent.new { "I checked the registry addresses." }
                  end
                end
              end
              render PhlexKit::Message.new do
                render PhlexKit::MessageAvatar.new do
                  render PhlexKit::Avatar.new do
                    render PhlexKit::AvatarImage.new(src: "https://github.com/shadcn.png", alt: "@shadcn")
                    render PhlexKit::AvatarFallback.new { "CN" }
                  end
                end
                render PhlexKit::MessageContent.new do
                  render PhlexKit::Bubble.new(variant: :muted) do
                    render PhlexKit::BubbleContent.new { "The component and example JSON now live under the UI registry." }
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
