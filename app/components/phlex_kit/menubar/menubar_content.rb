module PhlexKit
  # Dropdown panel of a MenubarMenu. See menubar.rb.
  class MenubarContent < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-menubar-content", popover: "manual", role: "menu" }, @attrs), &)
    end
  end
end
