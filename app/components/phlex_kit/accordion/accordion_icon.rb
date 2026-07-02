module PhlexKit
  class AccordionIcon < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&block)
      span(**mix({ class: "pk-accordion-icon", data: { phlex_kit__accordion_target: "icon" } }, @attrs)) do
        if block
          yield
        else
          svg(xmlns: "http://www.w3.org/2000/svg", viewbox: "0 0 20 20", fill: "currentColor") do |s|
            s.path(fill_rule: "evenodd", clip_rule: "evenodd", d: "M5.23 7.21a.75.75 0 011.06.02L10 11.168l3.71-3.938a.75.75 0 111.08 1.04l-4.25 4.5a.75.75 0 01-1.08 0l-4.25-4.5a.75.75 0 01.02-1.06z")
          end
        end
      end
    end
  end
end
