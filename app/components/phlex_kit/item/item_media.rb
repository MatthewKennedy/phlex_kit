module PhlexKit
  # Leading media slot of an Item. variant :icon sizes a glyph; :image crops a
  # square thumbnail (sized by the item's size modifier); :default is bare.
  # See item.rb.
  class ItemMedia < BaseComponent
    VARIANTS = { default: nil, icon: "icon", image: "image" }.freeze

    def initialize(variant: :default, **attrs)
      @variant = variant.to_sym
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({ class: [ "pk-item-media", VARIANTS.fetch(@variant) ].compact.join(" ") }, @attrs), &)
    end
  end
end
