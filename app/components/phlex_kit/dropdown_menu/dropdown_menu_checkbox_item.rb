module PhlexKit
  # Toggleable menu row, ported from shadcn/ui's DropdownMenuCheckboxItem: a
  # <label> around a real (hidden) checkbox — clicking toggles it natively and
  # the ✓ shows via CSS, without closing the menu (matching Radix). Pass
  # `name:`/`value:` to submit the state with a form. See dropdown_menu.rb.
  class DropdownMenuCheckboxItem < BaseComponent
    def initialize(checked: false, name: nil, value: "1", **attrs)
      @checked = checked
      @name = name
      @value = value
      @attrs = attrs
    end

    def view_template(&block)
      label(**mix({
        class: "pk-dropdown-menu-item pk-dropdown-menu-checkbox-item",
        role: "menuitemcheckbox"
      }, @attrs)) do
        input(type: :checkbox, class: "pk-dropdown-menu-item-input", name: @name, value: @value, checked: @checked)
        span(class: "pk-dropdown-menu-item-indicator", aria: { hidden: "true" }) { check_icon }
        yield if block
      end
    end

    private

    def check_icon
      render Icon.new(:check, size: nil)
    end
  end
end
