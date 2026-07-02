module PhlexKit
  # Constrains content (typically an <img>) to a fixed aspect ratio, ported from
  # ruby_ui's RubyUI::AspectRatio. `aspect_ratio:` is a "w/h" string (e.g. "16/9",
  # "1/1"); the classic padding-bottom box keeps the ratio. Tailwind → vanilla
  # `.pk-aspect-ratio*` (aspect_ratio.css).
  class AspectRatio < BaseComponent
    def initialize(aspect_ratio: "16/9", **attrs)
      unless aspect_ratio.is_a?(String) && aspect_ratio.include?("/")
        raise ArgumentError, %(aspect_ratio must be a "w/h" string (e.g. "16/9"))
      end
      @aspect_ratio = aspect_ratio
      @attrs = attrs
    end

    def view_template(&block)
      div(class: "pk-aspect-ratio", style: "padding-bottom: #{padding_bottom}%") do
        div(**mix({ class: "pk-aspect-ratio-inner" }, @attrs), &block)
      end
    end

    private

    def padding_bottom
      @aspect_ratio.split("/").map(&:to_i).reverse.reduce(&:fdiv) * 100
    end
  end
end
