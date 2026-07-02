# frozen_string_literal: true

module Docs
  module Examples
    module Link
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::Link.new(href: "#") { "Inline link" }
          render PhlexKit::Link.new(href: "#", variant: :outline) { "Button-styled link" }
          render PhlexKit::Link.new(href: "#", variant: :primary, size: :sm) { "Primary sm" }
        end
      end
    end
  end
end
