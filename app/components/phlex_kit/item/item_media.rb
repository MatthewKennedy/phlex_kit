module PhlexKit
  # Leading icon/avatar slot of an Item. See item.rb.
  class ItemMedia < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-item-media" }, @attrs), &)
  end
end
