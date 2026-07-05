# frozen_string_literal: true

module Docs
  module Examples
    module Badge
      class CustomColors < Phlex::HTML
        COLORS = {
          "Blue" => "background: light-dark(#eff6ff, #172554); color: light-dark(#1d4ed8, #93c5fd);",
          "Green" => "background: light-dark(#f0fdf4, #052e16); color: light-dark(#15803d, #86efac);",
          "Sky" => "background: light-dark(#f0f9ff, #082f49); color: light-dark(#0369a1, #7dd3fc);",
          "Purple" => "background: light-dark(#faf5ff, #3b0764); color: light-dark(#7e22ce, #d8b4fe);",
          "Red" => "background: light-dark(#fef2f2, #450a0a); color: light-dark(#b91c1c, #fca5a5);"
        }.freeze

        def view_template
          div(class: "row") do
            # Any palette works: override the pill's colors directly.
            COLORS.each do |name, style|
              render PhlexKit::Badge.new(style: style) { name }
            end
          end
        end
      end
    end
  end
end
