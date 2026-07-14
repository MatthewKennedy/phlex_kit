module PhlexKit
  # Chat message bubble. Ported from ruby_ui's RubyUI::Bubble. The variant colours
  # the child BubbleContent via a data-slot selector; align: :end flips it to the
  # trailing edge. Compose Bubble > BubbleContent (+ BubbleReactions).
  class Bubble < BaseComponent
    VARIANTS = %i[default secondary muted tinted outline ghost destructive].freeze
    ALIGNS = %i[start end].freeze
    def initialize(variant: :default, align: :start, **attrs)
      @variant = variant.to_sym
      raise KeyError, "unknown Bubble variant #{@variant}" unless VARIANTS.include?(@variant)
      @align = align.to_sym
      raise KeyError, "unknown Bubble align #{@align}" unless ALIGNS.include?(@align)
      @attrs = attrs
    end
    def view_template(&)
      div(**mix({ class: "pk-bubble", data: { slot: "bubble", variant: @variant, align: @align } }, @attrs), &)
    end
  end
end
