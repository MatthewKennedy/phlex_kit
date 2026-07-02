module PhlexKit
  class BubbleGroup < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-bubble-group", data: { slot: "bubble-group" } }, @attrs), &)
  end
end
