module PhlexKit
  # Tabbed panels. Ported from ruby_ui's RubyUI::Tabs. Compose Tabs(default:) >
  # (TabsList > TabsTrigger(value:)) + TabsContent(value:). phlex-kit--tabs.
  class Tabs < BaseComponent
    def initialize(default: nil, **attrs)
      @default = default
      @attrs = attrs
    end
    def view_template(&)
      div(**mix({ class: "pk-tabs", data: { controller: "phlex-kit--tabs", phlex_kit__tabs_active_value: @default } }, @attrs), &)
    end
  end
end
