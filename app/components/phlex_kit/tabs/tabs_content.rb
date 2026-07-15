module PhlexKit
  class TabsContent < BaseComponent
    # id: is a named kwarg (not left in **attrs) — see TabsTrigger.
    def initialize(value:, active: false, id: nil, **attrs)
      @value = value
      @active = active
      @id = id || "pk-tabs-panel-#{value}"
      @attrs = attrs
    end
    def view_template(&)
      # id / aria-labelledby mirror TabsTrigger's deterministic ids (re-scoped
      # per instance by the controller); tabindex="0" makes the panel itself
      # focusable, per the APG tabs pattern. `active:` (mirroring TabsTrigger's)
      # renders the panel visible pre-JS/no-JS; the controller's sync()
      # reconciles visibility from the active value after connect.
      div(**mix({ class: @active ? "pk-tabs-content" : "pk-tabs-content pk-hidden", role: "tabpanel", id: @id, aria_labelledby: "pk-tabs-trigger-#{@value}", tabindex: "0", data: { phlex_kit__tabs_target: "content", value: @value } }, @attrs), &)
    end
  end
end
