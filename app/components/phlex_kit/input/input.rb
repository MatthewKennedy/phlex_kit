module PhlexKit
  # Form text input, ported from ruby_ui's RubyUI::Input (https://ruby-ui.com).
  # ruby_ui's Tailwind strings are replaced with plain `.pk-input` CSS
  # (input.css) on the app's design tokens. Like upstream, it registers as a
  # phlex-kit--form-field input target — live validation kicks in when wrapped
  # in a PhlexKit::FormField, and Stimulus ignores the wiring otherwise.
  #
  # `type:` picks the HTML input type (:text, :email, :password, :number, …);
  # everything else — `name:`, `value:`, `id:`, `placeholder:`, `required:`,
  # `**on(...)` — rides the `mix` pass-through onto the <input>, so a caller's
  # `class:` augments rather than clobbers ours. This is a presentational
  # primitive, NOT a Rails form-builder helper: in a Phlex view you supply the
  # name/value yourself, exactly as Admin::ReviewRow composes PhlexKit::Button.
  #
  # No VARIANTS: an input is an input. Sizing/state live in CSS (:focus,
  # :disabled, [aria-invalid]).
  class Input < BaseComponent
    def initialize(type: :text, **attrs)
      @type = type
      @attrs = attrs
    end

    def view_template
      input(**mix({
        type: @type,
        class: "pk-input",
        data: {
          phlex_kit__form_field_target: "input",
          action: "input->phlex-kit--form-field#onInput invalid->phlex-kit--form-field#onInvalid"
        }
      }, @attrs))
    end
  end
end
