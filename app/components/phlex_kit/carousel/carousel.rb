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
          action: keyboard_action
        }
      }, @attrs), &)
    end

    private

    def default_options
      { axis: (@orientation == :horizontal) ? "x" : "y" }
    end

    # Arrow keys follow the scroll axis: left/right for horizontal, up/down
    # for vertical. Horizontal arrows route through keyNext/keyPrev, which
    # flip in RTL (the next slide sits to the physical left there).
    def keyboard_action
      if @orientation == :vertical
        "keydown.down->phlex-kit--carousel#scrollNext:prevent keydown.up->phlex-kit--carousel#scrollPrev:prevent"
      else
        "keydown.right->phlex-kit--carousel#keyNext:prevent keydown.left->phlex-kit--carousel#keyPrev:prevent"
      end
    end
  end
end
