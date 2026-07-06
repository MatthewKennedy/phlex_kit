module PhlexKit
  # Two-state pressable button. Ported from ruby_ui's RubyUI::Toggle. Renders a
  # wrapper (display:contents) holding the <button> and an optional hidden input so
  # the pressed state can post with a form. phlex-kit--toggle drives the state.
  class Toggle < BaseComponent
    VARIANTS = { default: nil, outline: "outline" }.freeze
    SIZES = { sm: "sm", default: nil, lg: "lg" }.freeze

    def self.modifier_classes(variant:, size:)
      [ VARIANTS.fetch(variant, nil), SIZES.fetch(size, nil) ].compact
    end

    def initialize(pressed: false, name: nil, value: "1", unpressed_value: nil,
                   variant: :default, size: :default, disabled: false, wrapper: {}, **attrs)
      @pressed = pressed
      @name = name
      @value = value
      @unpressed_value = unpressed_value
      @variant = variant.to_sym
      @size = size.to_sym
      @disabled = disabled
      @wrapper = wrapper
      @attrs = attrs
    end

    def view_template(&block)
      span(**mix(wrapper_default_attrs, @wrapper)) do
        button(**mix(button_default_attrs, @attrs), &block)
        render_hidden_input if @name
      end
    end

    private

    def classes
      ([ "pk-toggle" ] + self.class.modifier_classes(variant: @variant, size: @size)).join(" ")
    end

    def button_default_attrs
      a = { type: "button", class: classes, aria: { pressed: @pressed.to_s },
            data: { state: @pressed ? "on" : "off", phlex_kit__toggle_target: "button" } }
      a[:disabled] = true if @disabled
      a
    end

    def wrapper_default_attrs
      { class: "pk-contents", data: { controller: "phlex-kit--toggle",
        action: "click->phlex-kit--toggle#toggle",
        phlex_kit__toggle_pressed_value: @pressed.to_s,
        phlex_kit__toggle_value_value: @value.to_s,
        phlex_kit__toggle_unpressed_value_value: @unpressed_value.to_s } }
    end

    def render_hidden_input
      input(type: "hidden", name: @name, value: @pressed ? @value : @unpressed_value.to_s,
        data: { phlex_kit__toggle_target: "input" })
    end
  end
end
