module PhlexKit
  # Title/description column of an Item. See item.rb.
  class ItemContent < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-item-content" }, @attrs), &)
  end
end
