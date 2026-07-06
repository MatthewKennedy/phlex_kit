module PhlexKit
  class AccordionContent < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      # role="region" + aria-labelledby → trigger id (wired by the controller
      # in connect(), which also assigns the ids), per the APG accordion pattern.
      div(**mix({ class: "pk-accordion-content", role: "region", data: { phlex_kit__accordion_target: "content", state: "closed" }, style: "height: 0px;", hidden: true }, @attrs), &)
    end
  end
end
