module PhlexKit
  class EmptyTitle < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-empty-title" }, @attrs), &)
  end
end
