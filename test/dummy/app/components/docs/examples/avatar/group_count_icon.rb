# frozen_string_literal: true

module Docs
  module Examples
    module Avatar
      class GroupCountIcon < Phlex::HTML
        def view_template
          render PhlexKit::AvatarGroup.new(style: "filter: grayscale(1)") do
            render PhlexKit::Avatar.new do
              render PhlexKit::AvatarImage.new(src: "https://github.com/shadcn.png", alt: "@shadcn")
              render PhlexKit::AvatarFallback.new { "CN" }
            end
            render PhlexKit::Avatar.new do
              render PhlexKit::AvatarImage.new(src: "https://github.com/maxleiter.png", alt: "@maxleiter")
              render PhlexKit::AvatarFallback.new { "LR" }
            end
            render PhlexKit::Avatar.new do
              render PhlexKit::AvatarImage.new(src: "https://github.com/evilrabbit.png", alt: "@evilrabbit")
              render PhlexKit::AvatarFallback.new { "ER" }
            end
            render PhlexKit::AvatarGroupCount.new do
              render PhlexKit::Icon.new(:plus, size: nil)
            end
          end
        end
      end
    end
  end
end
