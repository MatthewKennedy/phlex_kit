module PhlexKit
  # One slide in a PhlexKit::CarouselContent. Full-width/-height by default
  # (basis 100%); override with `class:` for multi-up layouts. See carousel.rb.
  class CarouselItem < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({
        role: "group",
        aria: { roledescription: "slide" },
        class: "pk-carousel-item"
      }, @attrs), &)
    end
  end
end
