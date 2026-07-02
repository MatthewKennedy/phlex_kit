module PhlexKit
  class DialogMiddle < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-dialog-middle" }, @attrs), &)
  end
end
