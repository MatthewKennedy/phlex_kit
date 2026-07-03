# frozen_string_literal: true

module Docs
  module Examples
    module Shimmer
      class Default < Phlex::HTML
        def view_template
          p(class: "pk-shimmer", style: "font-size:.875rem;color:var(--pk-muted)") { "Generating response…" }
        end
      end
    end
  end
end
