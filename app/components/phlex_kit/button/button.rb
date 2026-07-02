module PhlexKit
  # Button, ported from ruby_ui's RubyUI::Button (https://ruby-ui.com) to full
  # variant/size parity. Renders a <button>; the `mix` pass-through means a
  # caller's `class:` augments ours and a phlex-reactive `**on(:event)` bundle
  # flows straight onto the element:
  #
  #   render PhlexKit::Button.new(variant: :primary, **on(:publish)) { "Approve" }
  #
  # For a button-styled link, put the classes on an <a> directly
  # (`class: "pk-button outline sm"`) — that's ruby_ui's Link approach.
  #
  # Variants/sizes mirror ruby_ui; Tailwind is replaced with vanilla `.pk-button`
  # CSS (button.css). `VARIANTS.fetch`/`SIZES.fetch` fail loud on a bad value.
  class Button < BaseComponent
    # variant => modifier class. Default is :primary (the filled brand button),
    # matching ruby_ui.
    VARIANTS = {
      primary: "primary",
      secondary: "secondary",
      destructive: "destructive",
      outline: "outline",
      ghost: "ghost",
      link: "link"
    }.freeze

    SIZES = {
      sm: "sm",
      md: nil,
      lg: "lg",
      xl: "xl"
    }.freeze

    def initialize(variant: :primary, size: :md, type: :button, icon: false, **attrs)
      @variant = variant.to_sym
      @size = size.to_sym
      @type = type
      @icon = icon
      @attrs = attrs
    end

    def view_template(&block)
      button(**mix({ type: @type, class: classes }, @attrs), &block)
    end

    private

    def classes
      [ "pk-button", VARIANTS.fetch(@variant), SIZES.fetch(@size), ("icon" if @icon) ].compact.join(" ")
    end
  end
end
