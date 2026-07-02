module PhlexKit
  # List row, ported from shadcn/ui's Item: a flex row of ItemMedia +
  # ItemContent(ItemTitle + ItemDescription) + ItemActions, optionally grouped
  # in an ItemGroup. variant :outline draws a bordered card row.
  # `.pk-item*` (item.css).
  class Item < BaseComponent
    VARIANTS = { default: nil, outline: "outline", muted: "muted" }.freeze

    def initialize(variant: :default, **attrs)
      @variant = variant.to_sym
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({ class: [ "pk-item", VARIANTS.fetch(@variant) ].compact.join(" ") }, @attrs), &)
    end
  end
end
