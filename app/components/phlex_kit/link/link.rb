module PhlexKit
  # Link, ported from ruby_ui's RubyUI::Link — an <a> that wears PhlexKit::Button's
  # look. Same variant/size vocabulary as Button, so it reuses the `.pk-button*`
  # classes from button.css (link.css only adds the inline :link treatment).
  # Default variant is :link (an inline underline-on-hover link); the button-style
  # variants turn it into a button-styled anchor (ruby_ui's "Link" concept — what
  # we already do ad-hoc with `a(class: "pk-button outline sm")`).
  #
  # Presentational; `mix` passes `**@attrs` (incl. data-*) straight through.
  # `VARIANTS.fetch`/`SIZES.fetch` fail loud.
  class Link < BaseComponent
    # Mirrors PhlexKit::Button's vocabulary 1:1 so the shared `.pk-button*` CSS applies.
    VARIANTS = {
      link: "link",
      primary: "primary",
      secondary: "secondary",
      destructive: "destructive",
      outline: "outline",
      ghost: "ghost"
    }.freeze

    SIZES = {
      sm: "sm",
      md: nil,
      lg: "lg",
      xl: "xl"
    }.freeze

    def initialize(href: "#", variant: :link, size: :md, icon: false, **attrs)
      @href = href
      @variant = variant.to_sym
      @size = size.to_sym
      @icon = icon
      @attrs = attrs
    end

    def view_template(&block)
      a(**mix({ href: @href, class: classes }, @attrs), &block)
    end

    private

    def classes
      [ "pk-button", VARIANTS.fetch(@variant), SIZES.fetch(@size), ("icon" if @icon) ].compact.join(" ")
    end
  end
end
