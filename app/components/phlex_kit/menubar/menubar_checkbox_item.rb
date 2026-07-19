module PhlexKit
  # Toggleable row, mirroring shadcn/ui's MenubarCheckboxItem: a <label>
  # around a real (hidden) checkbox — clicking toggles it natively and the ✓
  # shows via CSS, without closing the menu (matching Radix). See menubar.rb.
  class MenubarCheckboxItem < BaseComponent
    def initialize(checked: false, name: nil, value: "1", **attrs)
      @checked = checked
      @name = name
      @value = value
      @attrs = attrs
    end

    def view_template(&block)
      base = { class: "pk-menubar-item pk-menubar-checkbox-item" }
      # Defaults only when the caller didn't supply their own — `mix` fuses.
      base[:role] = "menuitemcheckbox" unless attr_set?(:role)
      base[:tabindex] = "-1" unless attr_set?(:tabindex)
      base[:"aria-checked"] = (@checked ? "true" : "false") unless aria_key_set?(:checked)
      label(**mix(base, @attrs)) do
        input(type: :checkbox, class: "pk-menubar-item-input", name: @name, value: @value, checked: @checked,
              tabindex: "-1", data: { action: "change->phlex-kit--menubar#syncChecked" })
        span(class: "pk-menubar-item-indicator", aria: { hidden: "true" }) do
          render Icon.new(:check, size: nil)
        end
        yield if block
      end
    end
  end
end
