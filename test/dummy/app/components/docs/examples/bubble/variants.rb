# frozen_string_literal: true

module Docs
  module Examples
    module Bubble
      class Variants < Phlex::HTML
        def view_template
          div(class: "stack w-md") do
            { default: "Default (own message)", secondary: "Secondary", muted: "Muted",
              tinted: "Tinted", outline: "Outline", destructive: "Destructive" }.each do |variant, label|
              render PhlexKit::Bubble.new(variant: variant) do
                render PhlexKit::BubbleContent.new { label }
              end
            end
          end
        end
      end
    end
  end
end
