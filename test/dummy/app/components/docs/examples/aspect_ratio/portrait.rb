# frozen_string_literal: true

module Docs
  module Examples
    module AspectRatio
      class Portrait < Phlex::HTML
        # ratio 9/16 — portrait image formats.
        def view_template
          div(style: "width: 220px; max-width: 100%") do
            render PhlexKit::AspectRatio.new(aspect_ratio: "9/16") do
              img(src: "https://images.unsplash.com/photo-1611348586804-61bf6c080437?w=600&dpr=2&q=80",
                alt: "Photo by Milad Fakurian", style: "width:100%;height:100%;object-fit:cover;border-radius:calc(var(--pk-radius) - 2px)")
            end
          end
        end
      end
    end
  end
end
