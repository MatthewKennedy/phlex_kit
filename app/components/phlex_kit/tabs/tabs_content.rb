module PhlexKit
  class TabsContent < BaseComponent
    def initialize(value:, **attrs)
      @value = value
      @attrs = attrs
    end
    def view_template(&)
      # id / aria-labelledby mirror TabsTrigger's deterministic ids (re-scoped
      # per instance by the controller); tabindex="0" makes the panel itself
      # focusable, per the APG tabs pattern.
      div(**mix({ class: "pk-tabs-content pk-hidden", role: "tabpanel", id: "pk-tabs-panel-#{@value}", aria_labelledby: "pk-tabs-trigger-#{@value}", tabindex: "0", data: { phlex_kit__tabs_target: "content", value: @value } }, @attrs), &)
    end
  end
end
