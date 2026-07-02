module PhlexKit
  # Click-triggered floating panel, positioned with CSS (no @floating-ui). Ported
  # from ruby_ui's RubyUI::Popover. Compose Popover > (PopoverTrigger +
  # PopoverContent). phlex-kit--popover.
  class Popover < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-popover", data: { controller: "phlex-kit--popover" } }, @attrs), &)
    end
  end
end
