module PhlexKit
  # A non-interactive heading inside a PhlexKit::DropdownMenuContent. See dropdown_menu.rb.
  class DropdownMenuLabel < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      h3(**mix({ class: "pk-dropdown-menu-label" }, @attrs), &block)
    end
  end
end
