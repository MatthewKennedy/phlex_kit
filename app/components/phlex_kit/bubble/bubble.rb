module PhlexKit
  # Chat message bubble. Ported from ruby_ui's RubyUI::Bubble. The variant colours
  # the child BubbleContent via a data-slot selector; align: :end flips it to the
  # trailing edge. Compose Bubble > BubbleContent (+ BubbleReactions).
  class Bubble < BaseComponent
    VARIANTS = %i[default secondary muted tinted outline ghost destructive].to_h { |v| [ v, v ] }.freeze
    ALIGNS = %i[start end].to_h { |v| [ v, v ] }.freeze
    def initialize(variant: :default, align: :start, **attrs)
      @variant = fetch_option(VARIANTS, variant.to_sym, :variant)
      @align = fetch_option(ALIGNS, align.to_sym, :align)
      @attrs = attrs
    end
    def view_template(&)
      div(**mix({ class: "pk-bubble", data: { slot: "bubble", variant: @variant, align: @align } }, @attrs), &)
    end
  end
end
