module PhlexKit
  # One choice in a ContextMenuRadioGroup — a <label> around a real (hidden)
  # radio; the ● shows via CSS and picking doesn't close the menu (matching
  # Radix). See context_menu.rb.
  class ContextMenuRadioItem < BaseComponent
    def initialize(name:, value:, checked: false, **attrs)
      @name = name
      @value = value
      @checked = checked
      @attrs = attrs
    end

    def view_template(&block)
      base = {
        class: "pk-context-menu-item pk-context-menu-radio-item",
        data: { phlex_kit__context_menu_target: "menuItem" }
      }
      # Defaults only when the caller didn't supply their own — `mix` fuses.
      base[:role] = "menuitemradio" unless attr_set?(:role)
      base[:tabindex] = "-1" unless attr_set?(:tabindex)
      base[:"aria-checked"] = (@checked ? "true" : "false") unless aria_key_set?(:checked)
      label(**mix(base, @attrs)) do
        input(type: :radio, class: "pk-context-menu-item-input", name: @name, value: @value, checked: @checked,
              tabindex: "-1", data: { action: "change->phlex-kit--context-menu#syncChecked" })
        span(class: "pk-context-menu-item-indicator", aria: { hidden: "true" }) do
          # A filled selection dot is geometry, not icon-library vocabulary —
          # identical across icon_library settings (matches the dropdown).
          svg(xmlns: "http://www.w3.org/2000/svg", viewbox: "0 0 24 24", fill: "currentColor") do |s|
            s.circle(cx: "12", cy: "12", r: "5")
          end
        end
        yield if block
      end
    end
  end
end
