module PhlexKit
  # Convenience trigger: label on the left, chevron icon on the right.
  class AccordionDefaultTrigger < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&block)
      button(**mix({ type: "button", class: "pk-accordion-trigger", data: { action: "click->phlex-kit--accordion#toggle" } }, @attrs)) do
        span(class: "pk-accordion-trigger-label", &block)
        render PhlexKit::AccordionIcon.new
      end
    end
  end
end
