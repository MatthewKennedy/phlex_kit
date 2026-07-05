# frozen_string_literal: true

module Docs
  module Examples
    module Avatar
      class Basic < Phlex::HTML
        def view_template
          render PhlexKit::Avatar.new do
            render PhlexKit::AvatarImage.new(src: "https://github.com/shadcn.png", alt: "@shadcn", style: "filter: grayscale(1)")
            render PhlexKit::AvatarFallback.new { "CN" }
          end
        end
      end
    end
  end
end
