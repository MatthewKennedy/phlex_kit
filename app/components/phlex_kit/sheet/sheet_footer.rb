module PhlexKit
  class SheetFooter < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-sheet-footer" }, @attrs), &)
  end
end
