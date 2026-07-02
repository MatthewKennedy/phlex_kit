module PhlexKit
  # Closes the drawer from inside the cloned panel (wrap a Button). See drawer.rb.
  class DrawerClose < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-drawer-close", data: { action: "click->phlex-kit--sheet-content#close" } }, @attrs), &)
    end
  end
end
