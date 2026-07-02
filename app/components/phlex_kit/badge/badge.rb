module PhlexKit
  # Pill/label badge, ported from ruby_ui's RubyUI::Badge to variant/size parity.
  # Same kit shape as PhlexKit::Button — a `variant:`/`size:` selector plus attrs/block
  # passed through to the <span>. ruby_ui's semantic variants are ported; its long
  # raw-colour palette (red/blue/teal/…) is omitted as unused. Tailwind → vanilla
  # `.pk-badge` CSS (badge.css). `VARIANTS.fetch` fails loud.
  class Badge < BaseComponent
    VARIANTS = {
      primary: "primary",
      secondary: "secondary",
      outline: "outline",
      destructive: "destructive",
      success: "success",
      warning: "warning"
    }.freeze

    SIZES = {
      sm: "sm",
      md: nil,
      lg: "lg"
    }.freeze

    def initialize(variant: :primary, size: :md, **attrs)
      @variant = variant.to_sym
      @size = size.to_sym
      @attrs = attrs
    end

    def view_template(&block)
      span(**mix({ class: classes }, @attrs), &block)
    end

    private

    def classes
      [ "pk-badge", VARIANTS.fetch(@variant), SIZES.fetch(@size) ].compact.join(" ")
    end
  end
end
