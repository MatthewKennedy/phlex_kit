module PhlexKit
  class BubbleContent < BaseComponent
    def initialize(as: :div, **attrs)
      @as = as
      @attrs = attrs
    end
    def view_template(&)
      send(@as, **mix({ class: "pk-bubble-content", data: { slot: "bubble-content" } }, @attrs), &)
    end
  end
end
