# frozen_string_literal: true

module Docs
  module Examples
    module Shimmer
      class Color < Phlex::HTML
        def view_template
          div(class: "stack", style: "font-size:.875rem;color:var(--pk-muted);text-align:center") do
            p(class: "pk-shimmer", style: "--pk-shimmer-color: color-mix(in oklch, #3b82f6 60%, transparent)") { "Generating response…" }
            p(class: "pk-shimmer", style: "--pk-shimmer-color: #378ADD") { "Generating response…" }
          end
        end
      end
    end
  end
end
