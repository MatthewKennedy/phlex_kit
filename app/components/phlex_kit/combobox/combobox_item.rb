module PhlexKit
  # One option row — a <label> wrapping a ComboboxCheckbox/ComboboxRadio, the
  # option text, and optionally a ComboboxItemIndicator. Being a label, clicking
  # anywhere toggles the input; the controller hides it (.pk-hidden) when
  # filtered out, assigns each option an id (for the combobox element's
  # aria-activedescendant), and keeps aria-selected in sync with the inner
  # input's checked state. See combobox.rb.
  class ComboboxItem < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      base = {
        class: "pk-combobox-item",
        data: { phlex_kit__combobox_target: "item" }
      }
      # Defaults only when the caller didn't supply their own — `mix` fuses
      # (a server-rendered initially-selected option sets its own selected).
      base[:role] = "option" unless attr_set?(:role)
      base[:aria] = { selected: "false" } unless aria_key_set?(:selected)
      label(**mix(base, @attrs), &)
    end
  end
end
