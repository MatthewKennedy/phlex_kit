# frozen_string_literal: true

module Docs
  module Examples
    module AspectRatio
      class Default < Phlex::HTML
        def view_template
          div(class: "w-md") do
            render PhlexKit::AspectRatio.new(aspect_ratio: "16/9") do
              img(src: "https://images.unsplash.com/photo-1588345921523-c2dcdb7f1dcd?w=800&dpr=2&q=80",
                alt: "Photo by Drew Beamer", style: "width:100%;height:100%;object-fit:cover;border-radius:var(--pk-radius)")
            end
          end
        end
      end
    end
  end
end
