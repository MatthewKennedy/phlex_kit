module PhlexKit
  # Show/hide a single region. Ported from ruby_ui's RubyUI::Collapsible. Compose
  # Collapsible > (CollapsibleTrigger + CollapsibleContent). phlex-kit--collapsible.
  class Collapsible < BaseComponent
    def initialize(open: false, **attrs)
      @open = open
      @attrs = attrs
    end
    def view_template(&)
      # data-state is the CSS styling hook (chevron rotation) — it must be
      # server-rendered or an open: true collapsible renders a closed-pointing
      # chevron until Stimulus connects (and always, with JS off).
      div(**mix({ class: "pk-collapsible", data: { controller: "phlex-kit--collapsible", phlex_kit__collapsible_open_value: @open, state: @open ? "open" : "closed" } }, @attrs), &)
    end
  end
end
