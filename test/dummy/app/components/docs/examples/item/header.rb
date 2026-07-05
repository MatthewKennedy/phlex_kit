# frozen_string_literal: true

module Docs
  module Examples
    module Item
      class Header < Phlex::HTML
        MODELS = [
          [ "v0-1.5-sm", "Everyday tasks and UI generation." ],
          [ "v0-1.5-lg", "Advanced thinking or reasoning." ],
          [ "v0-2.0-mini", "Open Source model for everyone." ]
        ].freeze

        def view_template
          div(style: "display: grid; grid-template-columns: repeat(3, 1fr); gap: 1rem; width: 100%; max-width: 36rem;") do
            MODELS.each do |name, description|
              render PhlexKit::Item.new(variant: :outline) do
                render PhlexKit::ItemHeader.new do
                  img(src: "https://avatar.vercel.sh/#{name}", alt: name, style: "aspect-ratio: 1; width: 100%; border-radius: calc(var(--pk-radius) - 4px); object-fit: cover;")
                end
                render PhlexKit::ItemContent.new do
                  render PhlexKit::ItemTitle.new { name }
                  render PhlexKit::ItemDescription.new { description }
                end
              end
            end
          end
        end
      end
    end
  end
end
