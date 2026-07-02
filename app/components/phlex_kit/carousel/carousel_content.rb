module PhlexKit
  # The clipping viewport + sliding track holding the CarouselItems. The
  # controller translates the track; orientation styling comes from the parent
  # .pk-carousel's is-horizontal/is-vertical modifier. See carousel.rb.
  class CarouselContent < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(class: "pk-carousel-viewport", data: { phlex_kit__carousel_target: "viewport" }) do
        div(**mix({ class: "pk-carousel-track" }, @attrs), &)
      end
    end
  end
end
