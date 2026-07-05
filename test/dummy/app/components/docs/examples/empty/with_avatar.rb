# frozen_string_literal: true

module Docs
  module Examples
    module Empty
      class WithAvatar < Phlex::HTML
        def view_template
          render PhlexKit::Empty.new(class: "w-md") do
            render PhlexKit::EmptyHeader.new do
              render PhlexKit::EmptyMedia.new do
                render PhlexKit::Avatar.new(size: :xl, style: "height: 3rem; width: 3rem;") do
                  render PhlexKit::AvatarImage.new(src: "https://github.com/shadcn.png", alt: "@shadcn", style: "filter: grayscale(1)")
                  render PhlexKit::AvatarFallback.new { "LR" }
                end
              end
              render PhlexKit::EmptyTitle.new { "User Offline" }
              render PhlexKit::EmptyDescription.new { "This user is currently offline. You can leave a message to notify them or try again later." }
            end
            render PhlexKit::EmptyContent.new do
              render PhlexKit::Button.new(size: :sm) { "Leave Message" }
            end
          end
        end
      end
    end
  end
end
