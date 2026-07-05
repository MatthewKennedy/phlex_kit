# frozen_string_literal: true

module Docs
  module Examples
    module Carousel
      class Spacing < Phlex::HTML
        def view_template
          div(style: "padding: 0 3.5rem") do
            render PhlexKit::Carousel.new(tabindex: "0", style: "width: 100%; max-width: 24rem;") do
              # Tighten the slide gap: shrink the track's negative margin and
              # each item's padding in lockstep (default is 1rem).
              render PhlexKit::CarouselContent.new(style: "margin-left: -.25rem") do
                5.times do |i|
                  render PhlexKit::CarouselItem.new(style: "flex-basis: 33.333%; padding-left: .25rem;") do
                    div(style: "padding: .25rem") do
                      render PhlexKit::Card.new do
                        render PhlexKit::CardContent.new(style: "display: flex; aspect-ratio: 1; align-items: center; justify-content: center; padding: 1.5rem;") do
                          span(style: "font-size: 1.5rem; font-weight: 600;") { (i + 1).to_s }
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
