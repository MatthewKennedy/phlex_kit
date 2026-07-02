module PhlexKit
  # The dropdown panel. Hidden until the trigger toggles it. `side:` is :bottom
  # (default, opens below) or :top (opens above — for triggers near the bottom of
  # the viewport, e.g. the sidebar footer). See dropdown_menu.rb.
  class DropdownMenuContent < BaseComponent
    def initialize(side: :bottom, **attrs)
      @side = side.to_sym
      @attrs = attrs
    end

    def view_template(&block)
      div(class: wrapper_classes, data: { phlex_kit__dropdown_menu_target: "content" }) do
        div(**mix({ class: "pk-dropdown-menu-viewport" }, @attrs), &block)
      end
    end

    private

    def wrapper_classes
      [ "pk-dropdown-menu-content", ("pk-dropdown-menu-content-up" if @side == :top), "hidden" ].compact.join(" ")
    end
  end
end
