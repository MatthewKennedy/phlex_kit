module PhlexKit
  # Conversation annotation, ported from shadcn/ui's Marker (an AI-chat-era
  # addition): an inline status line, bordered system-note row, or labeled
  # separator. Compose Marker(variant:) > [MarkerIcon +] MarkerContent.
  # `href:` renders an <a>, `as: :button` a <button> (their asChild) — both
  # underline and brighten on hover. `.pk-marker*` (marker.css).
  class Marker < BaseComponent
    VARIANTS = { default: nil, border: "border", separator: "separator" }.freeze

    def initialize(variant: :default, href: nil, as: :div, **attrs)
      @variant = variant.to_sym
      @href = href
      @as = as.to_sym
      @attrs = attrs
    end

    def view_template(&)
      classes = [ "pk-marker", VARIANTS.fetch(@variant) ].compact.join(" ")
      if @href
        a(**mix({ class: classes, href: @href }, @attrs), &)
      elsif @as == :button
        button(**mix({ class: classes, type: "button" }, @attrs), &)
      else
        div(**mix({ class: classes }, @attrs), &)
      end
    end
  end
end
