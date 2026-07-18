module PhlexKit
  # One slide in a PhlexKit::CarouselContent. Full-width/-height by default
  # (basis 100%); override with `class:` for multi-up layouts. See carousel.rb.
  class CarouselItem < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      base = { class: "pk-carousel-item" }
      # Defaults only when the caller didn't supply their own — `mix` fuses.
      base[:role] = "group" unless attr_set?(:role)
      base[:aria] = { roledescription: "slide" } unless aria_key_set?(:roledescription)
      div(**mix(base, @attrs), &)
    end
  end
end
