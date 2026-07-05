# frozen_string_literal: true

module Docs
  module Examples
    module Badge
      class Link < Phlex::HTML
        def view_template
          # href: renders an <a> — hover fills only apply to link badges.
          render PhlexKit::Badge.new(href: "#link") do
            plain "Open Link "
            render PhlexKit::Icon.new(:external_link, size: nil, data: { icon: "inline-end" })
          end
        end
      end
    end
  end
end
