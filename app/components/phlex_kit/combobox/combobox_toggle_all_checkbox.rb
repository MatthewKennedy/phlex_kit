module PhlexKit
  # "Select all" checkbox for a multi-select combobox — wrap it in a
  # PhlexKit::ComboboxItem as the FIRST row inside the ComboboxList (the item
  # carries role="option", which is only valid inside the listbox, and arrow-key
  # nav walks the list's rows). Hidden while a filter term is active.
  # See combobox.rb.
  class ComboboxToggleAllCheckbox < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      input(**mix({
        type: :checkbox,
        class: "pk-combobox-checkbox",
        data: {
          phlex_kit__combobox_target: "toggleAll",
          action: "change->phlex-kit--combobox#toggleAllItems"
        }
      }, @attrs))
    end
  end
end
