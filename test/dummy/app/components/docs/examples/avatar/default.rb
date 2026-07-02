# frozen_string_literal: true

module Docs
  module Examples
    module Avatar
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::Avatar.new do
            render PhlexKit::AvatarImage.new(src: "https://github.com/shadcn.png", alt: "@shadcn")
            render PhlexKit::AvatarFallback.new { "CN" }
          end
          render PhlexKit::Avatar.new(size: :lg) do
            render PhlexKit::AvatarFallback.new { "MK" }
          end
        end
      end
    end
  end
end
