module PhlexKit
  # Top-right action slot of a PhlexKit::Alert, ported from shadcn/ui's
  # AlertAction. Pins its content (typically a small Button) to the alert's
  # corner; the alert reserves right padding via :has(). See alert.rb.
  class AlertAction < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({ class: "pk-alert-action" }, @attrs), &block)
    end
  end
end
