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
      label(**mix({
        class: "pk-menubar-item pk-menubar-checkbox-item",
        role: "menuitemcheckbox"
      }, @attrs)) do
        input(type: :checkbox, class: "pk-menubar-item-input", name: @name, value: @value, checked: @checked)
        span(class: "pk-menubar-item-indicator", aria: { hidden: "true" }) do
          render Icon.new(:check, size: nil)
        end
        yield if block
      end
    end
  end
end
