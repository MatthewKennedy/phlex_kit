module PhlexKit
  # Trailing ✓ in a PhlexKit::ComboboxItem, visible (pure CSS) while the item's
  # input is checked. See combobox.rb.
  class ComboboxItemIndicator < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      svg(**mix({
        xmlns: "http://www.w3.org/2000/svg",
        width: "24",
        height: "24",
        viewbox: "0 0 24 24",
        fill: "none",
        stroke: "currentColor",
        "stroke-width": "2",
        "stroke-linecap": "round",
        "stroke-linejoin": "round",
        class: "pk-combobox-item-indicator",
        "aria-hidden": "true"
      }, @attrs)) do |s|
        s.path(d: "M20 6 9 17l-5-5")
      end
    end
  end
end
