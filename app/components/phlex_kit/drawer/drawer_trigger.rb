module PhlexKit
  # Opens the Drawer (wrap a Button). See drawer.rb.
  class DrawerTrigger < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-drawer-trigger", data: { action: "click->phlex-kit--sheet#open" } }, @attrs), &)
    end
  end
end
