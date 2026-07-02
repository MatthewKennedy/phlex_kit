module PhlexKit
  # The hidden input that actually carries PhlexKit::Select's value into the form — the
  # Stimulus controller writes the chosen item's value here and dispatches a
  # `change` (which also feeds phlex-kit--form-field validation when the select
  # sits inside a PhlexKit::FormField). Pass `name:`/`id:`/`value:` like any
  # input; it's display:none. See select.rb.
  class SelectInput < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      input(**mix({
        class: "pk-select-input",
        data: {
          phlex_kit__select_target: "input",
          phlex_kit__form_field_target: "input",
          action: "change->phlex-kit--form-field#onChange invalid->phlex-kit--form-field#onInvalid"
        }
      }, @attrs))
    end
  end
end
