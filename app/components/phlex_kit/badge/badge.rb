module PhlexKit
  # Pill/label badge, ported from ruby_ui's RubyUI::Badge and matched to
  # shadcn/ui's current badge. Same kit shape as PhlexKit::Button — a
  # `variant:`/`size:` selector plus attrs/block passed through. Pass `href:`
  # to render an <a> (shadcn's asChild link badge — hover fills only apply to
  # links). Mark leading/trailing svg glyphs with data-icon: "inline-start" /
  # "inline-end" to tighten the near-side padding, like theirs:
  #
  #   render PhlexKit::Badge.new(variant: :secondary) do
  #     render PhlexKit::Icon.new(:circle_check, size: nil, data: { icon: "inline-start" })
  #     plain "Verified"
  #   end
  #
  # shadcn ships default/secondary/destructive/outline/ghost/link (:primary is
  # their :default); success/warning and the sm/lg sizes are kit extras.
  # `VARIANTS.fetch` fails loud.
  class Badge < BaseComponent
    VARIANTS = {
      primary: "primary",
      secondary: "secondary",
      outline: "outline",
      destructive: "destructive",
      ghost: "ghost",
      link: "link",
      success: "success",
      warning: "warning"
    }.freeze

    SIZES = {
      sm: "sm",
      md: nil,
      lg: "lg"
    }.freeze

    def initialize(variant: :primary, size: :md, href: nil, **attrs)
      @variant = variant.to_sym
      @size = size.to_sym
      @href = href
      @attrs = attrs
    end

    def view_template(&block)
      if @href
        a(**mix({ class: classes, href: @href }, @attrs), &block)
      else
        span(**mix({ class: classes }, @attrs), &block)
      end
    end

    private

    def classes
      [ "pk-badge", VARIANTS.fetch(@variant), SIZES.fetch(@size) ].compact.join(" ")
    end
  end
end
