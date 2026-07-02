module PhlexKit
  class SheetTitle < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = h3(**mix({ class: "pk-sheet-title" }, @attrs), &)
  end
end
