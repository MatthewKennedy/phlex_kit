module PhlexKit
  class SheetMiddle < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-sheet-middle" }, @attrs), &)
  end
end
