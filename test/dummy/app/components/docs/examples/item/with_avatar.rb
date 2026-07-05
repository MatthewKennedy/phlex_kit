# frozen_string_literal: true

module Docs
  module Examples
    module Item
      class WithAvatar < Phlex::HTML
        def view_template
          div(class: "stack w-lg", style: "gap: 1.5rem") do
            render PhlexKit::Item.new(variant: :outline) do
              render PhlexKit::ItemMedia.new do
                render PhlexKit::Avatar.new(size: :lg) do
                  render PhlexKit::AvatarImage.new(src: "https://github.com/evilrabbit.png", alt: "@evilrabbit")
                  render PhlexKit::AvatarFallback.new { "ER" }
                end
              end
              render PhlexKit::ItemContent.new do
                render PhlexKit::ItemTitle.new { "Evil Rabbit" }
                render PhlexKit::ItemDescription.new { "Last seen 5 months ago" }
              end
              render PhlexKit::ItemActions.new do
                render PhlexKit::Button.new(size: :sm, variant: :outline, icon: true, style: "border-radius: 999px", aria: { label: "Invite" }) do
                  render PhlexKit::Icon.new(:plus, size: nil)
                end
              end
            end
            render PhlexKit::Item.new(variant: :outline) do
              render PhlexKit::ItemMedia.new do
                render PhlexKit::AvatarGroup.new(style: "filter: grayscale(1)") do
                  %w[shadcn maxleiter evilrabbit].each_with_index do |user, i|
                    render PhlexKit::Avatar.new do
                      render PhlexKit::AvatarImage.new(src: "https://github.com/#{user}.png", alt: "@#{user}")
                      render PhlexKit::AvatarFallback.new { %w[CN LR ER][i] }
                    end
                  end
                end
              end
              render PhlexKit::ItemContent.new do
                render PhlexKit::ItemTitle.new { "No Team Members" }
                render PhlexKit::ItemDescription.new { "Invite your team to collaborate on this project." }
              end
              render PhlexKit::ItemActions.new do
                render PhlexKit::Button.new(size: :sm, variant: :outline) { "Invite" }
              end
            end
          end
        end
      end
    end
  end
end
