module PhlexKit
  class AccordionItem < BaseComponent
    def initialize(open: false, disabled: false, rotate_icon: 180, **attrs)
      @open = open
      @disabled = disabled
      @rotate_icon = rotate_icon
      @attrs = attrs
    end
    def view_template(&)
      data = { controller: "phlex-kit--accordion", phlex_kit__accordion_open_value: @open, phlex_kit__accordion_rotate_icon_value: @rotate_icon }
      data[:disabled] = "" if @disabled
      div(**mix({ class: "pk-accordion-item", data: data }, @attrs), &)
    end
  end
end
