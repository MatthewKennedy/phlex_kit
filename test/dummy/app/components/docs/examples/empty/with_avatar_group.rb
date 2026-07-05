# frozen_string_literal: true

module Docs
  module Examples
    module Empty
      class WithAvatarGroup < Phlex::HTML
        def view_template
          render PhlexKit::Empty.new(class: "w-md") do
            render PhlexKit::EmptyHeader.new do
              render PhlexKit::EmptyMedia.new do
                render PhlexKit::AvatarGroup.new(style: "filter: grayscale(1)") do
                  %w[shadcn maxleiter evilrabbit].each_with_index do |user, i|
                    render PhlexKit::Avatar.new(style: "height: 3rem; width: 3rem;") do
                      render PhlexKit::AvatarImage.new(src: "https://github.com/#{user}.png", alt: "@#{user}")
                      render PhlexKit::AvatarFallback.new { %w[CN LR ER][i] }
                    end
                  end
                end
              end
              render PhlexKit::EmptyTitle.new { "No Team Members" }
              render PhlexKit::EmptyDescription.new { "Invite your team to collaborate on this project." }
            end
            render PhlexKit::EmptyContent.new do
              render PhlexKit::Button.new(size: :sm) do
                render PhlexKit::Icon.new(:plus, size: nil)
                plain "Invite Members"
              end
            end
          end
        end
      end
    end
  end
end
