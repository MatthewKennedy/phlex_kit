module PhlexKit
  # See drawer.rb.
  class DrawerHeader < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-drawer-header" }, @attrs), &)
  end
end
