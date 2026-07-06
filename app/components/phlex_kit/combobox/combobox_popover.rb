module PhlexKit
  # The combobox dropdown panel — like upstream, a native [popover] (manual:
  # the controller owns open/close and click-outside), anchor-positioned to
  # the combobox with viewport-edge flipping (combobox.css). The keyboard nav
  # actions ride on it, since focus sits in the search input inside. See
  # combobox.rb.
  class ComboboxPopover < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({
        class: "pk-combobox-popover",
        popover: "manual",
        data: {
          phlex_kit__combobox_target: "popover",
          action: [
            "keydown.down->phlex-kit--combobox#keyDownPressed",
            "keydown.up->phlex-kit--combobox#keyUpPressed",
            "keydown.enter->phlex-kit--combobox#keyEnterPressed",
            "keydown.esc->phlex-kit--combobox#closePopover:prevent"
          ].join(" ")
        }
      }, @attrs), &)
    end
  end
end
