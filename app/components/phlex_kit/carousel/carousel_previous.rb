module PhlexKit
  # Previous-slide button — an outline icon PhlexKit::Button anchored outside the
  # track edge (rotated 90° for vertical carousels). Starts disabled; the
  # controller enables it once there is somewhere to scroll. See carousel.rb.
  class CarouselPrevious < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      render Button.new(variant: :outline, icon: true, disabled: true, **mix({
        class: "pk-carousel-previous",
        data: { action: "click->phlex-kit--carousel#scrollPrev", phlex_kit__carousel_target: "prevButton" }
      }, @attrs)) do
        icon
        span(class: "pk-sr-only") { "Previous slide" }
      end
    end

    private

    def icon
      render Icon.new(:arrow_left, size: 24)
    end
  end
end
