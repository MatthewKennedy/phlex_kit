module PhlexKit
  class CollapsibleTrigger < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-collapsible-trigger", data: { action: "click->phlex-kit--collapsible#toggle" } }, @attrs), &)
    end
  end
end
