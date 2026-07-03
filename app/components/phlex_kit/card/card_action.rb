module PhlexKit
  # Top-right slot of a CardHeader (a button, link or badge) — the header
  # becomes a 1fr/auto grid when present. Ported from shadcn/ui's CardAction
  # (newer than ruby_ui's card). See card.rb.
  class CardAction < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({ class: "pk-card-action" }, @attrs), &)
    end
  end
end
