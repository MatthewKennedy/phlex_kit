module PhlexKit
  # The floating panel of a PhlexKit::HoverCard. `side:` picks the edge it
  # opens from (:bottom default, :top/:left/:right — shadcn's side prop).
  class HoverCardContent < BaseComponent
    SIDES = { bottom: nil, top: "top", left: "left", right: "right" }.freeze

    def initialize(side: :bottom, **attrs)
      @side = side.to_sym
      @attrs = attrs
    end

    def view_template(&)
      classes = [ "pk-hover-card-content", "pk-hidden", fetch_option(SIDES, @side, :side) ].compact.join(" ")
      div(**mix({ class: classes, data: { phlex_kit__hover_card_target: "content", state: "closed" } }, @attrs), &)
    end
  end
end
