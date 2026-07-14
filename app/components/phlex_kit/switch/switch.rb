module PhlexKit
  # On/off toggle rendered as a checkbox styled as a track+thumb. Ported from
  # ruby_ui's RubyUI::Switch — pure CSS (`:has(:checked)`), no Stimulus. Emits an
  # optional hidden field so an unchecked box still posts a value (Rails idiom).
  class Switch < BaseComponent
    SIZES = { md: nil, sm: "sm" }.freeze

    def initialize(include_hidden: true, checked_value: "1", unchecked_value: "0", size: :md, wrapper: {}, **attrs)
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
        input(**mix({ class: "pk-switch-input", role: "switch" }, @attrs).merge(type: "checkbox", value: @checked_value))
        span(class: "pk-switch-thumb")
      end
    end
  end
end
