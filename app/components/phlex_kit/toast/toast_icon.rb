module PhlexKit
  # Leading status icon for a PhlexKit::ToastItem. Renders nothing for :default /
  # nil (matching ruby_ui — only the status-ful variants get an icon); the
  # toaster swaps its innerHTML when a toast mutates (e.g. loading → success).
  # See toast_region.rb.
  class ToastIcon < BaseComponent
    def initialize(variant: nil, **attrs)
      @variant = variant&.to_sym
      @attrs = attrs
    end

    # Status → canonical glyph. Error is circle_x (octagon-x has no equivalent
    # outside Lucide, so the cross-library semantic name wins).
    GLYPHS = {
      success: :circle_check,
      error: :circle_x,
      warning: :triangle_alert,
      info: :info,
      loading: :loader
    }.freeze

    def view_template
      return unless renderable?
      span(**mix({ class: "pk-toast-icon", data: { slot: "icon" } }, @attrs)) do
        render Icon.new(fetch_option(GLYPHS, @variant, :glyph), size: 16, class: svg_classes)
      end
    end

    private

    def renderable?
      GLYPHS.key?(@variant)
    end

    def svg_classes
      [ "pk-toast-icon-svg", ("spin" if @variant == :loading) ].compact.join(" ")
    end
  end
end
