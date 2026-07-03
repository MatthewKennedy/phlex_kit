# frozen_string_literal: true

module Docs
  module Examples
    module AspectRatio
      class Square < Phlex::HTML
        # ratio 1/1 — square image formats.
        def view_template
          div(class: "w-sm") do
            render PhlexKit::AspectRatio.new(aspect_ratio: "1/1") do
              img(src: "https://images.unsplash.com/photo-1588345921523-c2dcdb7f1dcd?w=800&dpr=2&q=80",
                alt: "Photo by Drew Beamer", style: "width:100%;height:100%;object-fit:cover;border-radius:calc(var(--pk-radius) - 2px)")
            end
          end
        end
      end
    end
  end
end
