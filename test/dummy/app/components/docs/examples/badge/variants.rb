# frozen_string_literal: true

module Docs
  module Examples
    module Badge
      class Variants < Phlex::HTML
        def view_template
          div(class: "row") do
            render PhlexKit::Badge.new { "Default" }
            render PhlexKit::Badge.new(variant: :secondary) { "Secondary" }
            render PhlexKit::Badge.new(variant: :destructive) { "Destructive" }
            render PhlexKit::Badge.new(variant: :outline) { "Outline" }
            render PhlexKit::Badge.new(variant: :ghost) { "Ghost" }
          end
        end
      end
    end
  end
end
