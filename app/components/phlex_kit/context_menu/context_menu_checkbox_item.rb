module PhlexKit
  # Toggleable row, mirroring shadcn/ui's ContextMenuCheckboxItem: a <label>
  # around a real (hidden) checkbox — clicking toggles it natively and the ✓
  # shows via CSS, without closing the menu (matching Radix). Pass `name:`/
  # `value:` to submit the state with a form. See context_menu.rb.
  class ContextMenuCheckboxItem < BaseComponent
    def initialize(checked: false, name: nil, value: "1", **attrs)
      @checked = checked
      @name = name
      @value = value
      @attrs = attrs
    end

    def view_template(&block)
      base = {
        class: "pk-context-menu-item pk-context-menu-checkbox-item",
        data: { phlex_kit__context_menu_target: "menuItem" }
      }
      # Defaults only when the caller didn't supply their own — `mix` fuses.
      base[:role] = "menuitemcheckbox" unless attr_set?(:role)
      base[:tabindex] = "-1" unless attr_set?(:tabindex)
      base[:"aria-checked"] = (@checked ? "true" : "false") unless aria_key_set?(:checked)
      label(**mix(base, @attrs)) do
        input(type: :checkbox, class: "pk-context-menu-item-input", name: @name, value: @value, checked: @checked,
              tabindex: "-1", data: { action: "change->phlex-kit--context-menu#syncChecked" })
        span(class: "pk-context-menu-item-indicator", aria: { hidden: "true" }) do
          render Icon.new(:check, size: nil)
        end
        yield if block
      end
    end
  end
end
