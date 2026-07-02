module PhlexKit
  # See drawer.rb.
  class DrawerFooter < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-drawer-footer" }, @attrs), &)
  end
end
