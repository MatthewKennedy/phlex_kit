module PhlexKit
  # Footer region of a PhlexKit::Card — typically a row of PhlexKit::Buttons. See card.rb.
  class CardFooter < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({ class: "pk-card-footer" }, @attrs), &block)
    end
  end
end
