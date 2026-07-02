module PhlexKit
  class SheetTrigger < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-sheet-trigger", data: { action: "click->phlex-kit--sheet#open" } }, @attrs), &)
  end
end
