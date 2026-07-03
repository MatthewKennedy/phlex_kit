# frozen_string_literal: true

module Docs
  module Examples
    module Shimmer
      class DurationSpreadAngle < Phlex::HTML
        def view_template
          div(class: "stack", style: "font-size:.875rem;color:var(--pk-muted);text-align:center") do
            p(class: "pk-shimmer", style: "--pk-shimmer-duration: 1000ms") { "Faster — 1s per sweep" }
            p(class: "pk-shimmer", style: "--pk-shimmer-spread: 6rem") { "Wider highlight band" }
            p(class: "pk-shimmer", style: "--pk-shimmer-angle: 45deg") { "Tilted 45°" }
          end
        end
      end
    end
  end
end
