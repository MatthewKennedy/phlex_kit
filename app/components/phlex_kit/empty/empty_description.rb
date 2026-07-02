module PhlexKit
  class EmptyDescription < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-empty-description" }, @attrs), &)
  end
end
