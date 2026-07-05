# frozen_string_literal: true

module Docs
  module Examples
    module Button
      class AsChild < Phlex::HTML
        def view_template
          # href: renders an <a> styled as a button (their asChild).
          render PhlexKit::Button.new(href: "#login") { "Login" }
        end
      end
    end
  end
end
