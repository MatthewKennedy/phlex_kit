module PhlexKit
  # Single radio input. Ported from ruby_ui's RubyUI::RadioButton. Registers as
  # a phlex-kit--form-field input target, so it live-validates inside a
  # PhlexKit::FormField (Stimulus ignores the wiring otherwise).
  class RadioButton < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)

    def view_template
      input(**mix({
        type: :radio,
        class: "pk-radio",
        data: {
          phlex_kit__form_field_target: "input",
          action: "change->phlex-kit--form-field#onInput invalid->phlex-kit--form-field#onInvalid"
        }
      }, @attrs))
    end
  end
end
