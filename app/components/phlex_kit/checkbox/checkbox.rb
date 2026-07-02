module PhlexKit
  # Checkbox, ported from ruby_ui's RubyUI::Checkbox. ruby_ui pairs it with a
  # CheckboxGroup Stimulus controller (cross-box "at least one required"
  # coordination); that's deliberately NOT ported — it's client behaviour we
  # don't need yet, and per the kit's convention reactivity belongs in feature
  # components, not PhlexKit:: primitives. Like upstream it registers as a
  # phlex-kit--form-field input target (live validation inside a FormField);
  # `name:`/`value:`/`checked:`/`**on(...)` pass through via `mix`. Styled by
  # `.pk-checkbox` (checkbox.css).
  class Checkbox < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      input(**mix({
        type: :checkbox,
        class: "pk-checkbox",
        data: {
          phlex_kit__form_field_target: "input",
          action: "change->phlex-kit--form-field#onInput invalid->phlex-kit--form-field#onInvalid"
        }
      }, @attrs))
    end
  end
end
