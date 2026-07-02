# frozen_string_literal: true

module Docs
  module Examples
    module Button
      class AsLink < Phlex::HTML
        def view_template
          # A button-styled anchor: PhlexKit::Link with a button variant, or
          # put the classes on an <a> yourself.
          render PhlexKit::Link.new(href: "#", variant: :outline) { "Login" }
        end
      end
    end
  end
end
