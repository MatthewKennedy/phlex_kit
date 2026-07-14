module PhlexKit
  class BubbleReactions < BaseComponent
    SIDES = %i[top bottom].freeze
    ALIGNS = %i[start end].freeze
    def initialize(side: :bottom, align: :end, **attrs)
      @side = side.to_sym
      raise KeyError, "unknown BubbleReactions side #{@side}" unless SIDES.include?(@side)
      @align = align.to_sym
      raise KeyError, "unknown BubbleReactions align #{@align}" unless ALIGNS.include?(@align)
      @attrs = attrs
    end
    def view_template(&)
      div(**mix({ class: "pk-bubble-reactions", data: { slot: "bubble-reactions", side: @side, align: @align } }, @attrs), &)
    end
  end
end
