# frozen_string_literal: true

module Docs
  module Examples
    module Avatar
      class BadgeIcon < Phlex::HTML
        def view_template
          render PhlexKit::Avatar.new(style: "filter: grayscale(1)") do
            render PhlexKit::AvatarImage.new(src: "https://github.com/pranathip.png", alt: "@pranathip")
            render PhlexKit::AvatarFallback.new { "PP" }
            render PhlexKit::AvatarBadge.new do
              render PhlexKit::Icon.new(:plus, size: nil)
            end
          end
        end
      end
    end
  end
end
