module PhlexKit
  class AccordionContent < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-accordion-content", data: { phlex_kit__accordion_target: "content", state: "closed" }, style: "height: 0px;", hidden: true }, @attrs), &)
    end
  end
end
