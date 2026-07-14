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
      label(**mix({
        class: "pk-context-menu-item pk-context-menu-checkbox-item",
        role: "menuitemcheckbox",
        tabindex: "-1",
        aria: { checked: @checked ? "true" : "false" },
        data: { phlex_kit__context_menu_target: "menuItem" }
      }, @attrs)) do
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
