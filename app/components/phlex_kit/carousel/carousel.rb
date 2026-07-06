module PhlexKit
  # Carousel, ported from ruby_ui's RubyUI::Carousel. Upstream drives an
  # embla-carousel instance; that npm dependency is dropped — the
  # phlex-kit--carousel controller is a small translate-based engine (loop,
  # x/y axis from the options value, arrow keys, pointer drag/swipe, button
  # disabled state), so only @hotwired/stimulus is needed. Compose Carousel(orientation:) >
  # CarouselContent > CarouselItem(s), plus CarouselPrevious / CarouselNext.
  # Tailwind → vanilla `.pk-carousel*` (carousel.css).
  class Carousel < BaseComponent
    ORIENTATIONS = { horizontal: "is-horizontal", vertical: "is-vertical" }.freeze

    def initialize(orientation: :horizontal, options: {}, **attrs)
      @orientation = orientation.to_sym
      @options = options
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({
        class: [ "pk-carousel", fetch_option(ORIENTATIONS, @orientation, :orientation) ].join(" "),
        role: "region",
        aria: { roledescription: "carousel" },
        data: {
          controller: "phlex-kit--carousel",
          phlex_kit__carousel_options_value: JSON.generate(default_options.merge(@options)),
          action: "keydown.right->phlex-kit--carousel#scrollNext:prevent keydown.left->phlex-kit--carousel#scrollPrev:prevent"
        }
      }, @attrs), &)
    end

    private

    def default_options
      { axis: (@orientation == :horizontal) ? "x" : "y" }
    end
  end
end
