module PhlexKit
  # Body region of a PhlexKit::Card. See card.rb.
  class CardContent < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({ class: "pk-card-content" }, @attrs), &block)
    end
  end
end
