module PhlexKit
  class TabsTrigger < BaseComponent
    def initialize(value:, as: :button, **attrs)
      @value = value
      @as = as.to_sym
      @attrs = attrs
    end
    def view_template(&)
      base = { class: "pk-tabs-trigger", role: "tab", data: { phlex_kit__tabs_target: "trigger", action: "click->phlex-kit--tabs#show", value: @value } }
      if @as == :a
        a(**mix(base, @attrs), &)
      else
        button(**mix(base.merge(type: :button), @attrs), &)
      end
    end
  end
end
