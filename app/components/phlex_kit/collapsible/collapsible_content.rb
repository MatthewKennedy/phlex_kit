module PhlexKit
  class CollapsibleContent < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-collapsible-content", data: { phlex_kit__collapsible_target: "content" } }, @attrs), &)
    end
  end
end
