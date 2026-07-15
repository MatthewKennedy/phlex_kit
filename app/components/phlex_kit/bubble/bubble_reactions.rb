module PhlexKit
  class BubbleReactions < BaseComponent
    SIDES = %i[top bottom].to_h { |v| [ v, v ] }.freeze
    ALIGNS = %i[start end].to_h { |v| [ v, v ] }.freeze
    def initialize(side: :bottom, align: :end, **attrs)
      @side = fetch_option(SIDES, side.to_sym, :side)
      @align = fetch_option(ALIGNS, align.to_sym, :align)
      @attrs = attrs
    end
    def view_template(&)
      div(**mix({ class: "pk-bubble-reactions", data: { slot: "bubble-reactions", side: @side, align: @align } }, @attrs), &)
    end
  end
end
