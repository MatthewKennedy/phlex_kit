module PhlexKit
  # Wraps any element (typically a Button) so clicking it closes the enclosing
  # sheet, mirroring shadcn/ui's SheetClose. See sheet.rb.
  class SheetClose < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      span(**mix({ style: "display: contents;", data: { action: "click->phlex-kit--sheet-content#close" } }, @attrs), &)
    end
  end
end
