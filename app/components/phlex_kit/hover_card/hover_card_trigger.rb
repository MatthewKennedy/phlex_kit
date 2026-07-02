module PhlexKit
  class HoverCardTrigger < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-hover-card-trigger", data: { phlex_kit__hover_card_target: "trigger" } }, @attrs), &)
  end
end
