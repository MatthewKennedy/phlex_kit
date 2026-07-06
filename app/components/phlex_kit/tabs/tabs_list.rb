module PhlexKit
  class TabsList < BaseComponent
    VARIANTS = { default: nil, line: "line" }.freeze

    def initialize(variant: :default, **attrs)
      @variant = variant.to_sym
      @attrs = attrs
    end

    def view_template(&)
      classes = [ "pk-tabs-list", VARIANTS.fetch(@variant) ].compact.join(" ")
      div(**mix({ class: classes, role: "tablist", data: { phlex_kit__tabs_target: "list", action: "keydown->phlex-kit--tabs#keydown" } }, @attrs), &)
    end
  end
end
