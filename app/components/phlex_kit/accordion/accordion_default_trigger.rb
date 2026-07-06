module PhlexKit
  # Convenience trigger: label on the left, chevron icon on the right.
  class AccordionDefaultTrigger < BaseComponent
    def initialize(open: false, disabled: false, heading_level: 3, **attrs)
      raise ArgumentError, "heading_level must be 1..6" unless (1..6).cover?(heading_level)
      @open = open
      @disabled = disabled
      @heading_level = heading_level
      @attrs = attrs
    end
    def view_template(&block)
      # APG accordion: each trigger is a button wrapped in a heading.
      # aria-expanded reflects the render-time open state; the controller keeps
      # it in sync and wires aria-controls to the content's id in connect().
      base = {
        type: "button", class: "pk-accordion-trigger",
        aria_expanded: @open ? "true" : "false", disabled: @disabled,
        data: { phlex_kit__accordion_target: "trigger", action: "click->phlex-kit--accordion#toggle" }
      }
      send(:"h#{@heading_level}", class: "pk-accordion-heading") do
        button(**mix(base, @attrs)) do
          span(class: "pk-accordion-trigger-label", &block)
          render PhlexKit::AccordionIcon.new
        end
      end
    end
  end
end
