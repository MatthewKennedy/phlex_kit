module PhlexKit
  # The combobox dropdown panel. Upstream uses the native Popover API +
  # @floating-ui; here it's a CSS-positioned panel toggled with .pk-hidden (the
  # keyboard nav actions ride on it, since focus sits in the search input
  # inside). See combobox.rb.
  class ComboboxPopover < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({
        class: "pk-combobox-popover pk-hidden",
        data: {
          phlex_kit__combobox_target: "popover",
          action: [
            "keydown.down->phlex-kit--combobox#keyDownPressed",
            "keydown.up->phlex-kit--combobox#keyUpPressed",
            "keydown.enter->phlex-kit--combobox#keyEnterPressed",
            "keydown.esc->phlex-kit--combobox#closePopover:prevent",
            "resize@window->phlex-kit--combobox#updatePopoverWidth"
          ].join(" ")
        }
      }, @attrs), &)
    end
  end
end
