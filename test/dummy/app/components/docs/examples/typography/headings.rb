# frozen_string_literal: true

module Docs
  module Examples
    module Typography
      class Headings < Phlex::HTML
        def view_template
          div(class: "stack w-lg") do
            render PhlexKit::Heading.new(level: 1) { "Taxing Laughter: The Joke Tax Chronicles" }
            render PhlexKit::Heading.new(level: 2) { "The People of the Kingdom" }
            render PhlexKit::Heading.new(level: 3) { "The Joke Tax" }
            render PhlexKit::Heading.new(level: 4) { "People stopped telling jokes" }
          end
        end
      end
    end
  end
end
