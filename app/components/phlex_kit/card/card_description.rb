module PhlexKit
  # Muted subtitle under a PhlexKit::CardTitle — a <p>. See card.rb.
  class CardDescription < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      p(**mix({ class: "pk-card-description" }, @attrs), &block)
    end
  end
end
