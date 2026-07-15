module PhlexKit
  class TabsTrigger < BaseComponent
    def initialize(value:, as: :button, active: false, **attrs)
      @value = value
      @as = as.to_sym
      @active = active
      @attrs = attrs
    end
    def view_template(&)
      # Deterministic ids pair each trigger with its panel (aria-controls /
      # aria-labelledby); the controller re-scopes them per instance in
      # connect() so multiple tab sets sharing a value can't collide.
      # aria-selected and the roving tabindex are kept in sync by the
      # controller's activeValueChanged.
      base = {
        class: "pk-tabs-trigger", role: "tab", id: "pk-tabs-trigger-#{@value}",
        aria_selected: @active ? "true" : "false",
        aria_controls: "pk-tabs-panel-#{@value}",
        tabindex: @active ? "0" : "-1",
        # data-state is the only hook tabs.css styles the active trigger by —
        # it must be server-rendered or the active tab looks inactive pre-JS.
        data: { phlex_kit__tabs_target: "trigger", action: "click->phlex-kit--tabs#show", value: @value,
                state: @active ? "active" : "inactive" }
      }
      if @as == :a
        a(**mix(base, @attrs), &)
      else
        button(**mix(base.merge(type: :button), @attrs), &)
      end
    end
  end
end
