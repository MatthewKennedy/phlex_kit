module PhlexKit
  # Header region of PhlexKit::Card — stacks a CardTitle + CardDescription. See card.rb.
  class CardHeader < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({ class: "pk-card-header" }, @attrs), &block)
    end
  end
end
