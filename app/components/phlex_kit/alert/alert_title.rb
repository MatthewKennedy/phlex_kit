module PhlexKit
  # Heading line of a PhlexKit::Alert. A div, matching shadcn/ui's markup
  # (role="alert" on the box carries the semantics). See alert.rb.
  class AlertTitle < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({ class: "pk-alert-title" }, @attrs), &block)
    end
  end
end
