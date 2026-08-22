module PhlexKit
  # On/off toggle rendered as a checkbox styled as a track+thumb. Ported from
  # ruby_ui's RubyUI::Switch — pure CSS (`:has(:checked)`), no Stimulus. Emits an
  # optional hidden field so an unchecked box still posts a value (Rails idiom).
  # The checked value is plain `value:` (defaulting to "1"), same as Checkbox;
  # `unchecked_value:` is what the hidden field posts.
  class Switch < BaseComponent
    SIZES = { md: nil, sm: "sm" }.freeze

    def initialize(include_hidden: true, unchecked_value: "0", size: :md, wrapper: {}, **attrs)
      # checked_value: was the API through 0.15.0; the checked value is now
      # plain value:, matching Checkbox and HTML. Fail loud rather than let the
      # old kwarg land in **attrs, where it would render a bogus
      # checked_value="…" attribute while the real value reverts to "1".
      if attrs.key?(:checked_value) || attrs.key?("checked_value")
        raise ArgumentError, "Switch does not support checked_value: — pass the checked value as value:"
      end
      @include_hidden = include_hidden
      @unchecked_value = unchecked_value
      @size = size.to_sym
      @wrapper = wrapper
      @attrs = attrs
    end

    def view_template
      label(**mix({ class: [ "pk-switch", fetch_option(SIZES, @size, :size) ].compact.join(" ") }, @wrapper)) do
        # Never for array-style names ("ids[]") — an unchecked "0" would inject
        # a bogus element into the collection param (mirrors Checkbox).
        if @include_hidden && @attrs[:name] && !@attrs[:name].to_s.end_with?("[]")
          # Disabled in lockstep with the checkbox (Rails' check_box idiom) —
          # a disabled switch must not still post its unchecked value.
          # form: rides along too, so a form-attributed switch outside its
          # <form> posts the unchecked value to the same form.
          input(type: "hidden", name: @attrs[:name], value: @unchecked_value,
            disabled: @attrs[:disabled] ? true : nil,
            form: @attrs[:form] || @attrs["form"])
        end
        # role="switch" belongs on the focusable control: native checkedness then
        # maps to aria-checked for AT, and the label stays a plain label.
        # Default role only when the caller didn't supply their own — `mix` fuses.
        input_base = { class: "pk-switch-input" }
        input_base[:role] = "switch" unless attr_set?(:role)
        # Rails' check_box idiom: a switch with no explicit value posts "1".
        # Guarded because `mix` fuses String+String rather than overriding.
        input_base[:value] = "1" unless attr_set?(:value)
        input(**mix(input_base, @attrs).merge(type: "checkbox"))
        span(class: "pk-switch-thumb")
      end
    end
  end
end
