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
        svg(
          xmlns: "http://www.w3.org/2000/svg",
          width: "14",
          height: "14",
          viewbox: "0 0 24 24",
          fill: "none",
          stroke: "currentColor",
          "stroke-width": "2",
          "stroke-linecap": "round",
          "stroke-linejoin": "round",
          "aria-hidden": "true"
        ) do |s|
          s.path(d: "M18 6 6 18")
          s.path(d: "m6 6 12 12")
        end
        span(class: "pk-sr-only") { "Close" }
      end
    end
  end
end
