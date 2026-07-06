module PhlexKit
  # Button, ported from ruby_ui's RubyUI::Button and matched to shadcn/ui's
  # current button. Renders a <button>, or an <a> when `href:` is given
  # (their asChild link button). The `mix` pass-through means a caller's
  # `class:` augments ours and a phlex-reactive `**on(:event)` bundle flows
  # straight onto the element:
  #
  #   render PhlexKit::Button.new(variant: :primary, **on(:publish)) { "Approve" }
  #   render PhlexKit::Button.new(href: "/login") { "Login" }
  #
  # Mark leading/trailing glyphs with data-icon: "inline-start"/"inline-end"
  # to tighten the near-side padding like theirs. `icon: true` makes the
  # button square (their icon/icon-xs/… sizes — compose with `size:`).
  # :primary is their :default; :xl is a kit extra. `VARIANTS.fetch`/
  # `SIZES.fetch` fail loud on a bad value.
  class Button < BaseComponent
    # variant => modifier class. Default is :primary (the filled brand button).
    VARIANTS = {
      primary: "primary",
      secondary: "secondary",
      destructive: "destructive",
      outline: "outline",
      ghost: "ghost",
      link: "link"
    }.freeze

    SIZES = {
      xs: "xs",
      sm: "sm",
      md: nil,
      lg: "lg",
      xl: "xl"
    }.freeze

    def initialize(variant: :primary, size: :md, type: :button, icon: false, href: nil, **attrs)
      @variant = variant.to_sym
      @size = size.to_sym
      @type = type
      @icon = icon
      @href = href
      @attrs = attrs
    end

    def view_template(&block)
      if @href
        a(**mix({ href: @href, class: classes }, @attrs), &block)
      else
        button(**mix({ type: @type, class: classes }, @attrs), &block)
      end
    end

    private

    def classes
      [ "pk-button", fetch_option(VARIANTS, @variant, :variant), fetch_option(SIZES, @size, :size), ("icon" if @icon) ].compact.join(" ")
    end
  end
end
