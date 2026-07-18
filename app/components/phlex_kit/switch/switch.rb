module PhlexKit
  # On/off toggle rendered as a checkbox styled as a track+thumb. Ported from
  # ruby_ui's RubyUI::Switch — pure CSS (`:has(:checked)`), no Stimulus. Emits an
  # optional hidden field so an unchecked box still posts a value (Rails idiom).
  class Switch < BaseComponent
    SIZES = { md: nil, sm: "sm" }.freeze

    def initialize(include_hidden: true, checked_value: "1", unchecked_value: "0", size: :md, wrapper: {}, **attrs)
      # value: is silently clobbered below (the checkbox's real value comes
      # from checked_value:) — fail loud rather than let a caller's value:
      # vanish (mirrors ToggleGroupItem's unsupported-kwargs guard).
      if attrs.key?(:value) || attrs.key?("value")
        raise ArgumentError, "Switch does not support value: — the checkbox's value comes from checked_value:, pass that instead"
      end
      @include_hidden = include_hidden
      @checked_value = checked_value
      @unchecked_value = unchecked_value
      @size = size.to_sym
      @wrapper = wrapper
      @attrs = attrs
    end

    def view_template
      label(**mix({ class: [ "pk-switch", fetch_option(SIZES, @size, :size) ].compact.join(" ") }, @wrapper)) do
        if @include_hidden && @attrs[:name]
          # Disabled in lockstep with the checkbox (Rails' check_box idiom) —
          # a disabled switch must not still post its unchecked value.
          input(type: "hidden", name: @attrs[:name], value: @unchecked_value,
            disabled: @attrs[:disabled] ? true : nil)
        end
        # role="switch" belongs on the focusable control: native checkedness then
        # maps to aria-checked for AT, and the label stays a plain label.
        # Default role only when the caller didn't supply their own — `mix` fuses.
        input_base = { class: "pk-switch-input" }
        input_base[:role] = "switch" unless attr_set?(:role)
        input(**mix(input_base, @attrs).merge(type: "checkbox", value: @checked_value))
        span(class: "pk-switch-thumb")
      end
    end
  end
end
