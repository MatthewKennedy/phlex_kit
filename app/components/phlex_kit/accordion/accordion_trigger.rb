module PhlexKit
  class AccordionTrigger < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      button(**mix({ type: "button", class: "pk-accordion-trigger", data: { action: "click->phlex-kit--accordion#toggle" } }, @attrs), &)
    end
  end
end
