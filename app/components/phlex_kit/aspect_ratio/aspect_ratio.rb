module PhlexKit
  # Constrains content (typically an <img>) to a fixed aspect ratio, ported from
  # ruby_ui's RubyUI::AspectRatio. `aspect_ratio:` is a "w/h" string (e.g. "16/9",
  # "1/1"); the classic padding-bottom box keeps the ratio. Tailwind → vanilla
  # `.pk-aspect-ratio*` (aspect_ratio.css).
  class AspectRatio < BaseComponent
    def initialize(aspect_ratio: "16/9", **attrs)
      # Both terms must be positive integers — "16/0" yields Infinity% and
      # "a/b" NaN% padding, silently breaking the layout.
      unless aspect_ratio.is_a?(String) && aspect_ratio.match?(%r{\A[1-9]\d*/[1-9]\d*\z})
        raise ArgumentError, %(aspect_ratio must be a "w/h" string of positive integers (e.g. "16/9"))
      end
      @aspect_ratio = aspect_ratio
      @attrs = attrs
    end

    def view_template(&block)
      # **mix on the ROOT (kit rule) — caller attrs previously landed on the
      # inner div and could never reach the actual root element. Emit the
      # generated padding-bottom in the SAME form the caller used for style:,
      # because mix only composes same-typed values — it JOINS two strings
      # (the trailing ";" keeps the fused declaration valid) and MERGES two
      # hashes, but a string base against a caller hash (or vice versa) is
      # replaced wholesale, silently dropping our ratio and collapsing the box.
      caller_style = @attrs[:style] || @attrs["style"]
      generated_style =
        if caller_style.is_a?(Hash)
          { padding_bottom: "#{padding_bottom}%" }
        else
          "padding-bottom: #{padding_bottom}%;"
        end
      div(**mix({ class: "pk-aspect-ratio", style: generated_style }, @attrs)) do
        div(class: "pk-aspect-ratio-inner", &block)
      end
    end

    private

    def padding_bottom
      @aspect_ratio.split("/").map(&:to_i).reverse.reduce(&:fdiv) * 100
    end
  end
end
