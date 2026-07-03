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
          render Icon.new(:x, size: 15)
          span(class: "pk-sr-only") { "Close" }
        end
      end
    end
  end
end
