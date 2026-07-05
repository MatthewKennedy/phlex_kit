# frozen_string_literal: true

module Docs
  module Examples
    module Avatar
      class Sizes < Phlex::HTML
        def view_template
          div(class: "row", style: "filter: grayscale(1)") do
            render PhlexKit::Avatar.new(size: :sm) do
              render PhlexKit::AvatarImage.new(src: "https://github.com/shadcn.png", alt: "@shadcn")
              render PhlexKit::AvatarFallback.new { "CN" }
            end
            render PhlexKit::Avatar.new do
              render PhlexKit::AvatarImage.new(src: "https://github.com/shadcn.png", alt: "@shadcn")
              render PhlexKit::AvatarFallback.new { "CN" }
            end
            render PhlexKit::Avatar.new(size: :lg) do
              render PhlexKit::AvatarImage.new(src: "https://github.com/shadcn.png", alt: "@shadcn")
              render PhlexKit::AvatarFallback.new { "CN" }
            end
          end
        end
      end
    end
  end
end
