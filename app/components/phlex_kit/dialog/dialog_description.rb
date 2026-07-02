module PhlexKit
  class DialogDescription < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = p(**mix({ class: "pk-dialog-description" }, @attrs), &)
  end
end
