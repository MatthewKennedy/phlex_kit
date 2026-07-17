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
    # include_hidden mirrors Rails' check_box (and PhlexKit::Switch): an
    # unchecked box posts nothing, so a paired hidden field carries the
    # unchecked value. Emitted only when a `name:` is present — and never for
    # array-style names ("ids[]"), where an unchecked "0" would inject a
    # bogus element into the collection param (use a single blank hidden for
    # the whole collection instead, as Rails' collection helpers do).
    def initialize(include_hidden: true, unchecked_value: "0", **attrs)
      @include_hidden = include_hidden
      @unchecked_value = unchecked_value
      @attrs = attrs
    end

    def view_template
      if @include_hidden && @attrs[:name] && !@attrs[:name].to_s.end_with?("[]")
        # Disabled in lockstep with the checkbox (Rails' check_box idiom) —
        # a disabled checkbox must not still post its unchecked value.
        input(type: "hidden", name: @attrs[:name], value: @unchecked_value,
          disabled: @attrs[:disabled] ? true : nil)
      end
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
