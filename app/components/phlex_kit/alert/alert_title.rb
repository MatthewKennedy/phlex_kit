module PhlexKit
  # Heading line of a PhlexKit::Alert. See alert.rb.
  class AlertTitle < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      h5(**mix({ class: "pk-alert-title" }, @attrs), &block)
    end
  end
end
