module PhlexKit
  class EmptyContent < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-empty-content" }, @attrs), &)
  end
end
