module PhlexKit
  # See item.rb.
  class ItemTitle < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-item-title" }, @attrs), &)
  end
end
