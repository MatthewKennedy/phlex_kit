module PhlexKit
  # Scrollable option list in a PhlexKit::ComboboxPopover. See combobox.rb.
  class ComboboxList < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({ class: "pk-combobox-list", role: "listbox" }, @attrs), &)
    end
  end
end
