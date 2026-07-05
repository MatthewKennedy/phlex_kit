# frozen_string_literal: true

module Docs
  module Examples
    module Avatar
      class GroupCount < Phlex::HTML
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
            render PhlexKit::AvatarGroupCount.new { "+3" }
          end
        end
      end
    end
  end
end
