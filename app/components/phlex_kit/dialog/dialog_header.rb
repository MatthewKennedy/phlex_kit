module PhlexKit
  class DialogHeader < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-dialog-header" }, @attrs), &)
  end
end
