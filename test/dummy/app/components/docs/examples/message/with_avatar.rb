# frozen_string_literal: true

module Docs
  module Examples
    module Message
      class WithAvatar < Phlex::HTML
        def view_template
          div(class: "stack w-sm", style: "gap: 1.5rem; padding: 2rem 0;") do
            render PhlexKit::Message.new do
              render PhlexKit::MessageAvatar.new do
                render PhlexKit::Avatar.new do
                  render PhlexKit::AvatarImage.new(src: "https://github.com/evilrabbit.png", alt: "@evilrabbit")
                  render PhlexKit::AvatarFallback.new { "R" }
                end
              end
              render PhlexKit::MessageContent.new do
                render PhlexKit::Bubble.new(variant: :muted) do
                  render PhlexKit::BubbleContent.new { "The build failed during dependency installation." }
                end
              end
            end
            render PhlexKit::Message.new(align: :end) do
              render PhlexKit::MessageAvatar.new do
                render PhlexKit::Avatar.new do
                  render PhlexKit::AvatarImage.new(src: "https://github.com/shadcn.png", alt: "@shadcn")
                  render PhlexKit::AvatarFallback.new { "R" }
                end
              end
              render PhlexKit::MessageContent.new do
                render PhlexKit::Bubble.new do
                  render PhlexKit::BubbleContent.new { "Can you share the exact error?" }
                end
              end
            end
            render PhlexKit::Message.new do
              render PhlexKit::MessageAvatar.new do
                render PhlexKit::Avatar.new do
                  render PhlexKit::AvatarImage.new(src: "https://github.com/evilrabbit.png", alt: "@evilrabbit")
                  render PhlexKit::AvatarFallback.new { "R" }
                end
              end
              render PhlexKit::MessageContent.new do
                render PhlexKit::BubbleGroup.new do
                  render PhlexKit::Bubble.new(variant: :muted) do
                    render PhlexKit::BubbleContent.new { "Here's the error from the logs" }
                  end
                  render PhlexKit::Bubble.new(variant: :muted) do
                    render PhlexKit::BubbleContent.new { "Something went wrong with the build. The libraries are not installed correctly. Try running the build again." }
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
