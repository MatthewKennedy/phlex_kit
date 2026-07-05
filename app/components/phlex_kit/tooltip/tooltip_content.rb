module PhlexKit
  # The tooltip bubble. `side:` picks the edge it opens from (:top default,
  # :bottom/:left/:right — shadcn's side prop). See tooltip.rb.
  class TooltipContent < BaseComponent
    SIDES = { top: nil, bottom: "bottom", left: "left", right: "right" }.freeze

    def initialize(side: :top, **attrs)
      @side = side.to_sym
      @attrs = attrs
    end

    def view_template(&)
      classes = [ "pk-tooltip-content", SIDES.fetch(@side) ].compact.join(" ")
      div(**mix({ class: classes, role: "tooltip" }, @attrs), &)
    end
  end
end
