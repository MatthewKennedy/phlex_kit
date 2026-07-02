module PhlexKit
  class AccordionItem < BaseComponent
    def initialize(open: false, rotate_icon: 180, **attrs)
      @open = open
      @rotate_icon = rotate_icon
      @attrs = attrs
    end
    def view_template(&)
      div(**mix({ class: "pk-accordion-item", data: { controller: "phlex-kit--accordion", phlex_kit__accordion_open_value: @open, phlex_kit__accordion_rotate_icon_value: @rotate_icon } }, @attrs), &)
    end
  end
end
