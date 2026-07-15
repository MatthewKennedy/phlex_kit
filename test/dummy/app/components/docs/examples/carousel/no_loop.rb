# frozen_string_literal: true

module Docs
  module Examples
    module Carousel
      class NoLoop < Phlex::HTML
        def view_template
          div(style: "padding: 0 3.5rem") do
            render PhlexKit::Carousel.new(tabindex: "0", options: { loop: false }, style: "width: 100%; max-width: 24rem;") do
              render PhlexKit::CarouselContent.new do
                5.times do |i|
                  # Override the slide's flex-basis for multi-up layouts.
                  render PhlexKit::CarouselItem.new(style: "flex-basis: 33.333%") do
                    div(style: "padding: .25rem") do
                      render PhlexKit::Card.new do
                        render PhlexKit::CardContent.new(style: "display: flex; aspect-ratio: 1; align-items: center; justify-content: center; padding: 1.5rem;") do
                          span(style: "font-size: 1.875rem; font-weight: 600;") { (i + 1).to_s }
                        end
                      end
                    end
                  end
                end
              end
              render PhlexKit::CarouselPrevious.new
              render PhlexKit::CarouselNext.new
            end
          end
        end
      end
    end
  end
end
