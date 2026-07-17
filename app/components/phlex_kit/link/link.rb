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
      xs: "xs",
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
      base = { href: @href, class: classes }
      # target="_blank" hands the new page a window.opener reference in older
      # browsers (modern ones imply noopener) — default the safe rel unless
      # the caller supplied their own (`mix` would fuse "noopener external").
      base[:rel] = "noopener" if blank_target? && !attr_set?(:rel)
      a(**mix(base, @attrs), &block)
    end

    private

    def blank_target?
      (@attrs[:target] || @attrs["target"]).to_s == "_blank"
    end

    def classes
      [ "pk-button", fetch_option(VARIANTS, @variant, :variant), fetch_option(SIZES, @size, :size), ("icon" if @icon) ].compact.join(" ")
    end
  end
end
