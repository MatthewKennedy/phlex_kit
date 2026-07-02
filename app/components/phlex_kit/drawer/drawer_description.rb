module PhlexKit
  # See drawer.rb.
  class DrawerDescription < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = p(**mix({ class: "pk-drawer-description" }, @attrs), &)
  end
end
