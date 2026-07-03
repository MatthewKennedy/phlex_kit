# frozen_string_literal: true

module Docs
  module Examples
    module Shimmer
      class OnceAndReverse < Phlex::HTML
        def view_template
          div(class: "stack", style: "font-size:.875rem;color:var(--pk-muted);text-align:center") do
            # .once: a single sweep — a reveal when streaming completes.
            p(class: "pk-shimmer once", style: "--pk-shimmer-duration: 1100ms") { "Response generated." }
            p(class: "pk-shimmer reverse") { "Sweeping the other way" }
          end
        end
      end
    end
  end
end
