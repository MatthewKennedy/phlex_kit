module PhlexKit
  # Dropdown menu, ported from ruby_ui's RubyUI::DropdownMenu. Keeps the Stimulus
  # controller (toggle, click-outside, keyboard nav) but — like PhlexKit::Select — drops
  # the @floating-ui/dom dependency and positions the panel with CSS. Compose
  # Trigger + Content (+ Item / Label / Separator). Tailwind → vanilla
  # `.pk-dropdown-menu*` (dropdown_menu.css).
  class DropdownMenu < BaseComponent
    # `open: true` renders the menu open on connect (matching Collapsible's
    # kwarg -> Stimulus value -> connect flow).
    def initialize(open: false, **attrs)
      @open = open
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({
        class: "pk-dropdown-menu",
        data: {
          controller: "phlex-kit--dropdown-menu",
          phlex_kit__dropdown_menu_open_value: @open,
          # focusout: tabbing (or otherwise moving real focus) out of the
          # menu closes the open [popover=manual] panel (menubar's pattern).
          action: "click@window->phlex-kit--dropdown-menu#onClickOutside focusout->phlex-kit--dropdown-menu#onFocusout"
        }
      }, @attrs), &block)
    end
  end
end
