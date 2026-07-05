module PhlexKit
  # List row, ported from shadcn/ui's Item: a flex row of ItemMedia +
  # ItemContent(ItemTitle + ItemDescription) + ItemActions, optionally grouped
  # in an ItemGroup (with ItemSeparator) or stacked under an ItemHeader.
  # variant :outline draws a bordered card row; `size:` tightens (:sm/:xs);
  # `href:` renders an <a> (their asChild link item — hover fills apply).
  # `.pk-item*` (item.css).
  class Item < BaseComponent
    VARIANTS = { default: nil, outline: "outline", muted: "muted" }.freeze
    SIZES = { md: nil, sm: "sm", xs: "xs" }.freeze

    def initialize(variant: :default, size: :md, href: nil, **attrs)
      @variant = variant.to_sym
      @size = size.to_sym
      @href = href
      @attrs = attrs
    end

    def view_template(&)
      classes = [ "pk-item", VARIANTS.fetch(@variant), SIZES.fetch(@size) ].compact.join(" ")
      if @href
        a(**mix({ class: classes, href: @href }, @attrs), &)
      else
        div(**mix({ class: classes }, @attrs), &)
      end
    end
  end
end
