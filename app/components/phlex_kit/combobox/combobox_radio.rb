module PhlexKit
  # Single-select input inside a PhlexKit::ComboboxItem — selecting one closes the
  # popover. Also wired as a phlex-kit--form-field input so live validation works
  # when the combobox sits inside a PhlexKit::FormField. See combobox.rb.
  class ComboboxRadio < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      input(**mix({
        type: :radio,
        class: "pk-combobox-radio",
        data: {
          phlex_kit__combobox_target: "input",
          phlex_kit__form_field_target: "input",
          action: [
            "phlex-kit--combobox#inputChanged",
            "input->phlex-kit--form-field#onInput",
            "invalid->phlex-kit--form-field#onInvalid"
          ].join(" ")
        }
      }, @attrs))
    end
  end
end
