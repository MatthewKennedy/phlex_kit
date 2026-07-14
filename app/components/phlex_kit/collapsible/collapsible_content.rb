module PhlexKit
  # Collapsed region of a Collapsible. Pass `open:` matching the parent
  # Collapsible's so a closed region is hidden before JS (no flash-open, and
  # no stuck-open region without JS); the controller toggles `.pk-hidden`
  # from there. The default id lets the trigger's aria-controls point here.
  class CollapsibleContent < BaseComponent
    def initialize(open: false, id: nil, **attrs)
      @open = open
      @id = id || "pk-collapsible-content-#{SecureRandom.hex(4)}"
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({
        class: @open ? "pk-collapsible-content" : "pk-collapsible-content pk-hidden",
        id: @id,
        data: { phlex_kit__collapsible_target: "content" }
      }, @attrs), &)
    end
  end
end
