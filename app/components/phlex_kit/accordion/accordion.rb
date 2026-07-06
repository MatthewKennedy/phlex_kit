module PhlexKit
  # Vertically stacked, individually-collapsible sections. Ported from ruby_ui's
  # RubyUI::Accordion. Compose Accordion > AccordionItem > (AccordionTrigger +
  # AccordionContent). Animated open/close via the phlex-kit--accordion controller
  # (native Web Animations API — no `motion` dependency).
  class Accordion < BaseComponent
    # single (default, shadcn's): opening an item closes the others.
    TYPES = { single: "single", multiple: "multiple" }.freeze

    def initialize(type: :single, **attrs)
      @type = type.to_sym
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({ class: "pk-accordion", data: { type: fetch_option(TYPES, @type, :type) } }, @attrs), &)
    end
  end
end
