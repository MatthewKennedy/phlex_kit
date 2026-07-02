module PhlexKit
  class EmptyHeader < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-empty-header" }, @attrs), &)
  end
end
