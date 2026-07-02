module PhlexKit
  # See drawer.rb.
  class DrawerTitle < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = h2(**mix({ class: "pk-drawer-title" }, @attrs), &)
  end
end
