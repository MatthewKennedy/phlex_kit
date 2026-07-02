module PhlexKit
  # Stack of Items. See item.rb.
  class ItemGroup < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-item-group", role: "list" }, @attrs), &)
  end
end
