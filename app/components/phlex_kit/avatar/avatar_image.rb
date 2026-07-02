module PhlexKit
  # The image inside a PhlexKit::Avatar. NOT lazy-loaded on purpose (the controller
  # hides a not-yet-loaded image so the fallback shows; a lazy image that never
  # paints would never fire `load`). See avatar.rb.
  class AvatarImage < BaseComponent
    def initialize(src:, alt: "", **attrs)
      @src = src
      @alt = alt
      @attrs = attrs
    end

    def view_template
      img(**mix({
        src: @src,
        alt: @alt,
        class: "pk-avatar-image",
        data: {
          phlex_kit__avatar_target: "image",
          action: "load->phlex-kit--avatar#showImage error->phlex-kit--avatar#showFallback"
        }
      }, @attrs))
    end
  end
end
