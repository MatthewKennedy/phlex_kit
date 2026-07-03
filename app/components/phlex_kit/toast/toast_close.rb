module PhlexKit
  # The ×-in-the-corner close button, shown when the region has close_button:
  # true (or a spawn asks for one). See toast_region.rb.
  class ToastClose < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      button(**mix({
        type: :button,
        class: "pk-toast-close",
        aria: { label: "Close toast" },
        data: { slot: "close", action: "click->phlex-kit--toast#dismiss" }
      }, @attrs)) do
        render Icon.new(:x, size: 14)
        span(class: "pk-sr-only") { "Close" }
      end
    end
  end
end
