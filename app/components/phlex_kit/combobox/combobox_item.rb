module PhlexKit
  # One option row — a <label> wrapping a ComboboxCheckbox/ComboboxRadio, the
  # option text, and optionally a ComboboxItemIndicator. Being a label, clicking
  # anywhere toggles the input; the controller hides it (.pk-hidden) when
  # filtered out. See combobox.rb.
  class ComboboxItem < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      label(**mix({
        class: "pk-combobox-item",
        role: "option",
        data: { phlex_kit__combobox_target: "item" }
      }, @attrs), &)
    end
  end
end
