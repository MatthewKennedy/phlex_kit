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
      render Icon.new(:arrow_right, size: 24)
    end
  end
end
