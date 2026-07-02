module PhlexKit
  class TabsContent < BaseComponent
    def initialize(value:, **attrs)
      @value = value
      @attrs = attrs
    end
    def view_template(&)
      div(**mix({ class: "pk-tabs-content pk-hidden", role: "tabpanel", data: { phlex_kit__tabs_target: "content", value: @value } }, @attrs), &)
    end
  end
end
