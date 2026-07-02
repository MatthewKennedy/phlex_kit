module PhlexKit
  # The icon/avatar slot inside an Empty state. variant: :icon gives the tinted
  # rounded chip; :default is bare. Ported from ruby_ui's RubyUI::EmptyMedia.
  class EmptyMedia < BaseComponent
    VARIANTS = { default: nil, icon: "icon" }.freeze
    def initialize(variant: :default, **attrs)
      @variant = variant.to_sym
      @attrs = attrs
    end
    def view_template(&)
      div(**mix({ class: ["pk-empty-media", VARIANTS.fetch(@variant)].compact.join(" ") }, @attrs), &)
    end
  end
end
