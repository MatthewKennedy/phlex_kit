module PhlexKit
  # Empty-state container, ported from shadcn/ui's Empty.
  class Empty < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-empty" }, @attrs), &)
  end
end
