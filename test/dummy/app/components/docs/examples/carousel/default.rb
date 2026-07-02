# frozen_string_literal: true

module Docs
  module Examples
    module Carousel
      class Default < Phlex::HTML
        def view_template
          div(style: "padding: 0 3.5rem") do
            render PhlexKit::Carousel.new(tabindex: "0", class: "w-sm") do
              render PhlexKit::CarouselContent.new do
                5.times do |i|
                  render PhlexKit::CarouselItem.new do
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
