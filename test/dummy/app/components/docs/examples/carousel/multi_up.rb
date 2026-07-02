# frozen_string_literal: true

module Docs
  module Examples
    module Carousel
      class MultiUp < Phlex::HTML
        def view_template
          div(style: "padding: 0 3.5rem") do
            render PhlexKit::Carousel.new(tabindex: "0", class: "w-md") do
              render PhlexKit::CarouselContent.new do
                6.times do |i|
                  render PhlexKit::CarouselItem.new(style: "flex-basis: 50%") do
                    div(class: "docs-slide") { (i + 1).to_s }
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
