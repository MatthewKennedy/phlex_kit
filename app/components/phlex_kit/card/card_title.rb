module PhlexKit
  # Title line of a PhlexKit::Card header — an <h3>. See card.rb.
  class CardTitle < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      h3(**mix({ class: "pk-card-title" }, @attrs), &block)
    end
  end
end
