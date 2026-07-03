module PhlexKit
  # Trailing ✓ in a PhlexKit::ComboboxItem, visible (pure CSS) while the item's
  # input is checked. See combobox.rb.
  class ComboboxItemIndicator < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      render Icon.new(:check, size: 24, **mix({ class: "pk-combobox-item-indicator" }, @attrs))
    end
  end
end
