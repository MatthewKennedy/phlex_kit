# frozen_string_literal: true

module Docs
  module Examples
    module Typography
      class InlineCode < Phlex::HTML
        def view_template
          render PhlexKit::Text.new do
            plain "The tax was implemented as "
            render PhlexKit::InlineCode.new { "@phlex_kit/joke_tax" }
            plain " with an "
            render PhlexKit::InlineLink.new(href: "#") { "official decree" }
            plain "."
          end
        end
      end
    end
  end
end
