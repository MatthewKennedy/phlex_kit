module PhlexKit
  class DialogTitle < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = h3(**mix({ class: "pk-dialog-title" }, @attrs), &)
  end
end
