module PhlexKit
  # Two-state pressable button. Ported from ruby_ui's RubyUI::Toggle. Renders a
  # wrapper (display:contents) holding the <button> and an optional hidden input so
  # the pressed state can post with a form. phlex-kit--toggle drives the state.
  class Toggle < BaseComponent
    VARIANTS = { default: nil, outline: "outline" }.freeze
    SIZES = { sm: "sm", md: nil, lg: "lg" }.freeze

    def self.modifier_classes(variant:, size:)
      # Plain fetch — an unknown variant/size raises KeyError (kit-wide
      # fail-loud rule); the nil-default form silently rendered unstyled.
      [ VARIANTS.fetch(variant), SIZES.fetch(size) ].compact
    end

    def initialize(pressed: false, name: nil, value: "1", unchecked_value: nil, include_hidden: true,
                   variant: :default, size: :md, disabled: false, wrapper: {}, **attrs)
      # unpressed_value: was the API through 0.15.0 — the off value is now
      # spelled unchecked_value:, matching Checkbox and Switch. Fail loud
      # rather than let the old kwarg land in **attrs, where it would render a
      # bogus unpressed_value="…" attribute and silently drop the value.
      if attrs.key?(:unpressed_value) || attrs.key?("unpressed_value")
        raise ArgumentError, "Toggle does not support unpressed_value: — pass the off value as unchecked_value:"
      end
      @pressed = pressed
      @include_hidden = include_hidden
      @name = name
      @value = value
      @unchecked_value = unchecked_value
      @variant = variant.to_sym
      @size = size.to_sym
      @disabled = disabled
      @wrapper = wrapper
      @attrs = attrs
    end

    def view_template(&block)
      span(**mix(wrapper_default_attrs, @wrapper)) do
        button(**mix(button_default_attrs, @attrs), &block)
        render_hidden_input if @include_hidden && @name
      end
    end

    private

    def classes
      ([ "pk-toggle" ] + self.class.modifier_classes(variant: @variant, size: @size)).join(" ")
    end

    def button_default_attrs
      a = { type: :button, class: classes, aria: { pressed: @pressed.to_s },
            data: { state: @pressed ? "on" : "off", phlex_kit__toggle_target: "button" } }
      a[:disabled] = true if @disabled
      a
    end

    def wrapper_default_attrs
      { class: "pk-contents", data: { controller: "phlex-kit--toggle",
        action: "click->phlex-kit--toggle#toggle",
        phlex_kit__toggle_pressed_value: @pressed.to_s,
        phlex_kit__toggle_value_value: @value.to_s,
        phlex_kit__toggle_unchecked_value_value: @unchecked_value.to_s } }
    end

    def render_hidden_input
      # Disabled in lockstep with the button — a disabled toggle must not
      # submit its value (matches native disabled-control form semantics).
      a = { type: "hidden", name: @name, value: @pressed ? @value : @unchecked_value.to_s,
            data: { phlex_kit__toggle_target: "input" } }
      a[:disabled] = true if @disabled
      input(**a)
    end
  end
end
