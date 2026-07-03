module PhlexKit
  class AccordionIcon < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&block)
      span(**mix({ class: "pk-accordion-icon", data: { phlex_kit__accordion_target: "icon" } }, @attrs)) do
        if block
          yield
        else
          render Icon.new(:chevron_down, size: nil)
        end
      end
    end
  end
end
