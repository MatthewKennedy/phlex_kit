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
      base = { class: @active ? "pk-tabs-content" : "pk-tabs-content pk-hidden", role: "tabpanel", id: @id, data: { phlex_kit__tabs_target: "content", value: @value } }
      # Generated defaults only when the caller didn't supply their own —
      # `mix` fuses (custom-id trigger pairing / a non-focusable panel).
      base[:aria_labelledby] = "pk-tabs-trigger-#{@value}" unless aria_key_set?(:labelledby)
      base[:tabindex] = "0" unless attr_set?(:tabindex)
      div(**mix(base, @attrs), &)
    end
  end
end
