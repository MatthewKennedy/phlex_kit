module PhlexKit
  # Trailing actions slot of an Item. See item.rb.
  class ItemActions < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-item-actions" }, @attrs), &)
  end
end
