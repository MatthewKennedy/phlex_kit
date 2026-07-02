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
      svg(
        xmlns: "http://www.w3.org/2000/svg",
        width: "24",
        height: "24",
        viewbox: "0 0 24 24",
        fill: "none",
        stroke: "currentColor",
        "stroke-width": "2",
        "stroke-linecap": "round",
        "stroke-linejoin": "round",
        "aria-hidden": "true"
      ) do |s|
        s.path(d: "m12 19-7-7 7-7")
        s.path(d: "M19 12H5")
      end
    end
  end
end
