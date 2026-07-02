module PhlexKit
  # Vertically stacked, individually-collapsible sections. Ported from ruby_ui's
  # RubyUI::Accordion. Compose Accordion > AccordionItem > (AccordionTrigger +
  # AccordionContent). Animated open/close via the phlex-kit--accordion controller
  # (native Web Animations API — no `motion` dependency).
  class Accordion < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-accordion" }, @attrs), &)
  end
end
