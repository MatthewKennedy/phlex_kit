# frozen_string_literal: true

module Docs
  module Examples
    module Avatar
      class Badge < Phlex::HTML
        def view_template
          render PhlexKit::Avatar.new do
            render PhlexKit::AvatarImage.new(src: "https://github.com/shadcn.png", alt: "@shadcn")
            render PhlexKit::AvatarFallback.new { "CN" }
            # A presence dot — recolor with style/class (here: green).
            render PhlexKit::AvatarBadge.new(style: "background: light-dark(#16a34a, #166534)")
          end
        end
      end
    end
  end
end
