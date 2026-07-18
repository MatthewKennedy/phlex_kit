module PhlexKit
  class TabsTrigger < BaseComponent
    # id: is a named kwarg (not left in **attrs) because `mix` would *merge* a
    # caller id with the deterministic one into an invalid two-token id,
    # breaking the aria pairing pre-JS (and scopeIds' caller-id detection).
    AS_TAGS = %i[button a].freeze

    def initialize(value:, as: :button, active: false, id: nil, **attrs)
      @value = value
      @as = as.to_sym
      unless AS_TAGS.include?(@as)
        raise ArgumentError, "unknown TabsTrigger as: #{@as.inspect} (use one of #{AS_TAGS.join(", ")})"
      end
      @active = active
      @id = id || "pk-tabs-trigger-#{value}"
      @attrs = attrs
    end
    def view_template(&)
      # Deterministic ids pair each trigger with its panel (aria-controls /
      # aria-labelledby); the controller re-scopes them per instance in
      # connect() so multiple tab sets sharing a value can't collide.
      # aria-selected and the roving tabindex are kept in sync by the
      # controller's activeValueChanged.
      base = {
        class: "pk-tabs-trigger", role: "tab", id: @id,
        aria_selected: @active ? "true" : "false",
        tabindex: @active ? "0" : "-1",
        # data-state is the only hook tabs.css styles the active trigger by —
        # it must be server-rendered or the active tab looks inactive pre-JS.
        data: { phlex_kit__tabs_target: "trigger", action: "click->phlex-kit--tabs#show", value: @value,
                state: @active ? "active" : "inactive" }
      }
      # Generated idref default only when the caller didn't supply their own
      # (pairing with a custom-id TabsContent) — `mix` fuses.
      base[:aria_controls] = "pk-tabs-panel-#{@value}" unless aria_key_set?(:controls)
      if @as == :a
        a(**mix(base, @attrs), &)
      else
        button(**mix(base.merge(type: :button), @attrs), &)
      end
    end
  end
end
