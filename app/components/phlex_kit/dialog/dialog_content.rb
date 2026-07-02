module PhlexKit
  class DialogContent < BaseComponent
    SIZES = { xs: "xs", sm: "sm", md: nil, lg: "lg", xl: "xl", full: "full" }.freeze
    def initialize(size: :md, **attrs)
      @size = size.to_sym
      @attrs = attrs
    end
    def view_template(&block)
      cls = ["pk-dialog", SIZES.fetch(@size)].compact.join(" ")
      dialog(**mix({ class: cls, data: { phlex_kit__dialog_target: "dialog", action: "click->phlex-kit--dialog#backdropClick" } }, @attrs)) do
        yield
        button(type: "button", class: "pk-overlay-close", data: { action: "click->phlex-kit--dialog#dismiss" }) do
          svg(width: "15", height: "15", viewbox: "0 0 15 15", fill: "none", xmlns: "http://www.w3.org/2000/svg") do |s|
          s.path(fill_rule: "evenodd", clip_rule: "evenodd", fill: "currentColor", d: "M11.7816 4.03157C12.0062 3.80702 12.0062 3.44295 11.7816 3.2184C11.5571 2.99385 11.193 2.99385 10.9685 3.2184L7.50005 6.68682L4.03164 3.2184C3.80708 2.99385 3.44301 2.99385 3.21846 3.2184C2.99391 3.44295 2.99391 3.80702 3.21846 4.03157L6.68688 7.49999L3.21846 10.9684C2.99391 11.193 2.99391 11.557 3.21846 11.7816C3.44301 12.0061 3.80708 12.0061 4.03164 11.7816L7.50005 8.31316L10.9685 11.7816C11.193 12.0061 11.5571 12.0061 11.7816 11.7816C12.0062 11.557 12.0062 11.193 11.7816 10.9684L8.31322 7.49999L11.7816 4.03157Z")
        end
          span(class: "pk-sr-only") { "Close" }
        end
      end
    end
  end
end
