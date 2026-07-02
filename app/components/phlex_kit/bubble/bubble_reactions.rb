module PhlexKit
  class BubbleReactions < BaseComponent
    def initialize(side: :bottom, align: :end, **attrs)
      @side = side.to_sym
      @align = align.to_sym
      @attrs = attrs
    end
    def view_template(&)
      div(**mix({ class: "pk-bubble-reactions", data: { slot: "bubble-reactions", side: @side, align: @align } }, @attrs), &)
    end
  end
end
