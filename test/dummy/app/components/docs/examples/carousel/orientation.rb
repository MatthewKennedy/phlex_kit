# frozen_string_literal: true

module Docs
  module Examples
    module Carousel
      class Orientation < Phlex::HTML
        def view_template
          div(style: "padding: 3.5rem 0") do
            render PhlexKit::Carousel.new(orientation: :vertical, tabindex: "0", style: "width: 100%; max-width: 20rem;") do
              render PhlexKit::CarouselContent.new(style: "height: 270px") do
                5.times do |i|
                  render PhlexKit::CarouselItem.new(style: "flex-basis: 50%") do
                    div(style: "padding: .25rem") do
                      render PhlexKit::Card.new do
                        render PhlexKit::CardContent.new(style: "display: flex; align-items: center; justify-content: center; padding: 1.5rem;") do
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
