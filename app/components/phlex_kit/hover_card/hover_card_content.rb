module PhlexKit
  class HoverCardContent < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-hover-card-content pk-hidden", data: { phlex_kit__hover_card_target: "content", state: "closed" } }, @attrs), &)
    end
  end
end
