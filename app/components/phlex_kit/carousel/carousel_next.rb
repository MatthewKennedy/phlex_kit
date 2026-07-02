module PhlexKit
  # Next-slide button — the CarouselPrevious counterpart on the trailing edge.
  # See carousel.rb.
  class CarouselNext < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      render Button.new(variant: :outline, icon: true, disabled: true, **mix({
        class: "pk-carousel-next",
        data: { action: "click->phlex-kit--carousel#scrollNext", phlex_kit__carousel_target: "nextButton" }
      }, @attrs)) do
        icon
        span(class: "pk-sr-only") { "Next slide" }
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
        s.path(d: "M5 12h14")
        s.path(d: "m12 5 7 7-7 7")
      end
    end
  end
end
