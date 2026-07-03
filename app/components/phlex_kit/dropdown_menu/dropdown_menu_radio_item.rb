module PhlexKit
  # One choice in a DropdownMenuRadioGroup — a <label> around a real (hidden)
  # radio; the ● shows via CSS and picking doesn't close the menu (matching
  # Radix). See dropdown_menu.rb.
  class DropdownMenuRadioItem < BaseComponent
    def initialize(name:, value:, checked: false, **attrs)
      @name = name
      @value = value
      @checked = checked
      @attrs = attrs
    end

    def view_template(&block)
      label(**mix({
        class: "pk-dropdown-menu-item pk-dropdown-menu-radio-item",
        role: "menuitemradio"
      }, @attrs)) do
        input(type: :radio, class: "pk-dropdown-menu-item-input", name: @name, value: @value, checked: @checked)
        span(class: "pk-dropdown-menu-item-indicator", aria: { hidden: "true" }) do
          # Deliberately NOT a PhlexKit::Icon: a filled selection dot is
          # geometry, not icon-library vocabulary — it stays identical across
          # icon_library settings (shadcn fills its Circle icon via CSS too).
          svg(xmlns: "http://www.w3.org/2000/svg", viewbox: "0 0 24 24", fill: "currentColor") do |s|
            s.circle(cx: "12", cy: "12", r: "5")
          end
        end
        yield if block
      end
    end
  end
end
