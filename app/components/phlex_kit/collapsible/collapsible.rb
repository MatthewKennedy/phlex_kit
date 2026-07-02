module PhlexKit
  # Show/hide a single region. Ported from ruby_ui's RubyUI::Collapsible. Compose
  # Collapsible > (CollapsibleTrigger + CollapsibleContent). phlex-kit--collapsible.
  class Collapsible < BaseComponent
    def initialize(open: false, **attrs)
      @open = open
      @attrs = attrs
    end
    def view_template(&)
      div(**mix({ class: "pk-collapsible", data: { controller: "phlex-kit--collapsible", phlex_kit__collapsible_open_value: @open } }, @attrs), &)
    end
  end
end
