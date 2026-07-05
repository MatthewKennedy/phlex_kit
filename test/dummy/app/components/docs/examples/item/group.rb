# frozen_string_literal: true

module Docs
  module Examples
    module Item
      class Group < Phlex::HTML
        PEOPLE = [
          %w[shadcn shadcn@vercel.com CN],
          %w[maxleiter maxleiter@vercel.com LR],
          %w[evilrabbit evilrabbit@vercel.com ER]
        ].freeze

        def view_template
          div(class: "w-sm") do
            render PhlexKit::ItemGroup.new do
              PEOPLE.each do |username, email, initials|
                render PhlexKit::Item.new(variant: :outline) do
                  render PhlexKit::ItemMedia.new do
                    render PhlexKit::Avatar.new do
                      render PhlexKit::AvatarImage.new(src: "https://github.com/#{username}.png", alt: "@#{username}", style: "filter: grayscale(1)")
                      render PhlexKit::AvatarFallback.new { initials }
                    end
                  end
                  render PhlexKit::ItemContent.new do
                    render PhlexKit::ItemTitle.new { username }
                    render PhlexKit::ItemDescription.new { email }
                  end
                  render PhlexKit::ItemActions.new do
                    render PhlexKit::Button.new(variant: :ghost, icon: true, style: "border-radius: 999px", aria: { label: "Add #{username}" }) do
                      render PhlexKit::Icon.new(:plus, size: nil)
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
