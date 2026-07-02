module PhlexKit
  # Body text of a PhlexKit::Alert. See alert.rb.
  class AlertDescription < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({ class: "pk-alert-description" }, @attrs), &block)
    end
  end
end
