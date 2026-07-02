module PhlexKit
  # The control that opens a PhlexKit::DropdownMenu (wrap a PhlexKit::Button). See dropdown_menu.rb.
  class DropdownMenuTrigger < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({
        class: "pk-dropdown-menu-trigger",
        data: { phlex_kit__dropdown_menu_target: "trigger", action: "click->phlex-kit--dropdown-menu#toggle" }
      }, @attrs), &block)
    end
  end
end
