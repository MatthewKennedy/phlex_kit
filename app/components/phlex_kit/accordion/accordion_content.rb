module PhlexKit
  class AccordionContent < BaseComponent
    # Pass `open: true` alongside AccordionItem(open: true) so the content is
    # readable without JS — the closed-state hidden + height:0 otherwise makes
    # a server-rendered open item unreachable pre-hydration.
    def initialize(open: false, **attrs)
      @open = open
      @attrs = attrs
    end

    def view_template(&)
      # role="region" + aria-labelledby → trigger id (wired by the controller
      # in connect(), which also assigns the ids), per the APG accordion pattern.
      base = { class: "pk-accordion-content", data: { phlex_kit__accordion_target: "content", state: @open ? "open" : "closed" } }
      # Default only when the caller didn't supply their own — `mix` fuses.
      base[:role] = "region" unless attr_set?(:role)
      base.merge!(style: "height: 0px;", hidden: true) unless @open
      div(**mix(base, @attrs), &)
    end
  end
end
