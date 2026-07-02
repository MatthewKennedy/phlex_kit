# frozen_string_literal: true

module Docs
  module Examples
    module Typography
      class Default < Phlex::HTML
        def view_template
          div(class: "stack w-lg") do
            render PhlexKit::Heading.new(level: 1) { "Taxing Laughter" }
            render PhlexKit::Heading.new(level: 2) { "The People of the Kingdom" }
            render PhlexKit::Text.new do
              plain "The king, seeing how much happier his subjects were, realized the error of his ways and repealed the "
              render PhlexKit::InlineCode.new { "joke_tax" }
              plain "."
            end
            render PhlexKit::Blockquote.new { "\"After all,\" he said, \"everyone enjoys a good joke.\"" }
            render PhlexKit::Text.new do
              plain "Read the "
              render PhlexKit::InlineLink.new(href: "#") { "full story" }
              plain "."
            end
          end
        end
      end
    end
  end
end
