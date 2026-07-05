module PhlexKit
  # Tabbed panels. Ported from ruby_ui's RubyUI::Tabs. Compose Tabs(default:) >
  # (TabsList > TabsTrigger(value:)) + TabsContent(value:). phlex-kit--tabs.
  class Tabs < BaseComponent
    ORIENTATIONS = { horizontal: nil, vertical: "vertical" }.freeze

    def initialize(default: nil, orientation: :horizontal, **attrs)
      @default = default
      @orientation = orientation.to_sym
      @attrs = attrs
    end

    def view_template(&)
      classes = [ "pk-tabs", ORIENTATIONS.fetch(@orientation) ].compact.join(" ")
      div(**mix({ class: classes, data: { controller: "phlex-kit--tabs", phlex_kit__tabs_active_value: @default } }, @attrs), &)
    end
  end
end
