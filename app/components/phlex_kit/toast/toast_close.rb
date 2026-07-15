module PhlexKit
  # The ×-in-the-corner close button, shown when the region has close_button:
  # true (or a spawn asks for one). See toast_region.rb.
  class ToastClose < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      base = {
        type: :button,
        class: "pk-toast-close",
        data: { slot: "close", action: "click->phlex-kit--toast#dismiss" }
      }
      # Default label only when the caller didn't supply their own — `mix`
      # would fuse aria-label into a two-token value instead of overriding.
      base[:aria] = { label: "Close toast" } unless aria_labelled?
      button(**mix(base, @attrs)) do
        render Icon.new(:x, size: 14)
        span(class: "pk-sr-only") { "Close" }
      end
    end
  end
end
