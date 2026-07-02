module PhlexKit
  class SheetDescription < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = p(**mix({ class: "pk-sheet-description" }, @attrs), &)
  end
end
