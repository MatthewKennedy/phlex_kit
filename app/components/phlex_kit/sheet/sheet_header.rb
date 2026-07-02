module PhlexKit
  class SheetHeader < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-sheet-header" }, @attrs), &)
  end
end
