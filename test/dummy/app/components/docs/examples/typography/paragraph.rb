# frozen_string_literal: true

module Docs
  module Examples
    module Typography
      class Paragraph < Phlex::HTML
        def view_template
          div(class: "w-lg") do
            render PhlexKit::Text.new do
              "The king thought long and hard, and finally came up with a brilliant plan: he would tax the jokes in the kingdom."
            end
            render PhlexKit::Blockquote.new do
              "\"After all,\" he said, \"everyone enjoys a good joke, so it's only fair that they should pay for the privilege.\""
            end
          end
        end
      end
    end
  end
end
