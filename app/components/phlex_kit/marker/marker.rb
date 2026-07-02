module PhlexKit
  # Conversation annotation, ported from shadcn/ui's Marker (an AI-chat-era
  # addition): an inline status line, bordered system-note row, or labeled
  # separator. Compose Marker(variant:) > [MarkerIcon +] MarkerContent.
  # `.pk-marker*` (marker.css).
  class Marker < BaseComponent
    VARIANTS = { default: nil, border: "border", separator: "separator" }.freeze

    def initialize(variant: :default, **attrs)
      @variant = variant.to_sym
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({ class: [ "pk-marker", VARIANTS.fetch(@variant) ].compact.join(" ") }, @attrs), &)
    end
  end
end
