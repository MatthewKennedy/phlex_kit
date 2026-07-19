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
      base = {
        class: "pk-dropdown-menu-item pk-dropdown-menu-checkbox-item",
        data: { phlex_kit__dropdown_menu_target: "menuItem" }
      }
      # Defaults only when the caller didn't supply their own — `mix` fuses.
      base[:role] = "menuitemcheckbox" unless attr_set?(:role)
      base[:tabindex] = "-1" unless attr_set?(:tabindex)
      base[:"aria-checked"] = (@checked ? "true" : "false") unless aria_key_set?(:checked)
      label(**mix(base, @attrs)) do
        input(type: :checkbox, class: "pk-dropdown-menu-item-input", name: @name, value: @value, checked: @checked,
              tabindex: "-1", data: { action: "change->phlex-kit--dropdown-menu#syncChecked" })
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
