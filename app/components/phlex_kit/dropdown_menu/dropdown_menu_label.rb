module PhlexKit
  # A non-interactive heading inside a PhlexKit::DropdownMenuContent. See dropdown_menu.rb.
  class DropdownMenuLabel < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      # div, not a heading: role="menu" only allows menuitem/group/separator
      # children, so an <h3> is invalid ARIA there (shadcn uses a div too).
      div(**mix({ class: "pk-dropdown-menu-label" }, @attrs), &block)
    end
  end
end
