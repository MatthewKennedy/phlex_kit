module PhlexKit
  class DialogFooter < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-dialog-footer" }, @attrs), &)
  end
end
