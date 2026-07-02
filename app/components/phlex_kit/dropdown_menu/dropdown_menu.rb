module PhlexKit
  # Dropdown menu, ported from ruby_ui's RubyUI::DropdownMenu. Keeps the Stimulus
  # controller (toggle, click-outside, keyboard nav) but — like PhlexKit::Select — drops
  # the @floating-ui/dom dependency and positions the panel with CSS. Compose
  # Trigger + Content (+ Item / Label / Separator). Tailwind → vanilla
  # `.pk-dropdown-menu*` (dropdown_menu.css).
  class DropdownMenu < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({
        class: "pk-dropdown-menu",
        data: {
          controller: "phlex-kit--dropdown-menu",
          action: "click@window->phlex-kit--dropdown-menu#onClickOutside"
        }
      }, @attrs), &block)
    end
  end
end
