module PhlexKit
  class AccordionDefaultContent < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-accordion-default-content" }, @attrs), &)
  end
end
