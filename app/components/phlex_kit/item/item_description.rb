module PhlexKit
  # See item.rb.
  class ItemDescription < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-item-description" }, @attrs), &)
  end
end
