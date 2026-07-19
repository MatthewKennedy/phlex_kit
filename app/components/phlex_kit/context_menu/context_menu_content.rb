module PhlexKit
  class ContextMenuContent < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      base = { class: "pk-context-menu-content", data: { phlex_kit__context_menu_target: "content", state: "closed" } }
      # Defaults only when the caller didn't supply their own — `mix` fuses.
      base[:popover] = "manual" unless attr_set?(:popover)
      base[:role] = "menu" unless attr_set?(:role)
      base[:tabindex] = "-1" unless attr_set?(:tabindex)
      base[:aria] = { orientation: "vertical" } unless aria_key_set?(:orientation)
      div(**mix(base, @attrs), &)
    end
  end
end
