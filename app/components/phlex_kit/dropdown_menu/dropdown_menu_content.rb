module PhlexKit
  # The dropdown panel — a native [popover=manual] the trigger toggles,
  # anchor-positioned with viewport-edge flipping. `side:` is :bottom
  # (default, opens below), :top (opens above — for triggers near the bottom
  # of the viewport, e.g. the sidebar footer), :right or :left (opens beside
  # the trigger — shadcn's side prop). See dropdown_menu.rb.
  class DropdownMenuContent < BaseComponent
    SIDES = { bottom: nil, top: "pk-dropdown-menu-content-up", left: "pk-dropdown-menu-content-left", right: "pk-dropdown-menu-content-right" }.freeze

    def initialize(side: :bottom, **attrs)
      @side = side.to_sym
      @attrs = attrs
    end

    def view_template(&block)
      div(class: wrapper_classes, popover: "manual", data: { phlex_kit__dropdown_menu_target: "content" }) do
        base = { class: "pk-dropdown-menu-viewport" }
        # role="menu" on the items' direct parent — the rows render
        # role="menuitem", which is invalid ARIA without a menu ancestor.
        # Default only when the caller didn't supply their own — `mix` fuses.
        base[:role] = "menu" unless attr_set?(:role)
        div(**mix(base, @attrs), &block)
      end
    end

    private

    def wrapper_classes
      [ "pk-dropdown-menu-content", fetch_option(SIDES, @side, :side) ].compact.join(" ")
    end
  end
end
