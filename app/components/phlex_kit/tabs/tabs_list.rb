module PhlexKit
  class TabsList < BaseComponent
    VARIANTS = { default: nil, line: "line" }.freeze

    def initialize(variant: :default, orientation: :horizontal, **attrs)
      @variant = variant.to_sym
      @orientation = orientation.to_sym
      @attrs = attrs
    end

    def view_template(&)
      classes = [ "pk-tabs-list", fetch_option(VARIANTS, @variant, :variant) ].compact.join(" ")
      base = { class: classes, role: "tablist", data: { phlex_kit__tabs_target: "list", action: "keydown->phlex-kit--tabs#keydown" } }
      # Server-rendered so AT hears the right axis pre-JS / with JS off; the
      # controller re-stamps it on connect from the root's vertical class.
      base[:aria] = { orientation: "vertical" } if @orientation == :vertical
      div(**mix(base, @attrs), &)
    end
  end
end
