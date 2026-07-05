module PhlexKit
  # The <dialog> box. `size:` picks the width tier (md = shadcn's default
  # max-w-sm); `show_close_button: false` drops the top-right ✕ (their
  # showCloseButton). See dialog.rb.
  class DialogContent < BaseComponent
    SIZES = { xs: "xs", sm: "sm", md: nil, lg: "lg", xl: "xl", full: "full" }.freeze

    def initialize(size: :md, show_close_button: true, **attrs)
      @size = size.to_sym
      @show_close_button = show_close_button
      @attrs = attrs
    end

    def view_template(&block)
      cls = [ "pk-dialog", SIZES.fetch(@size) ].compact.join(" ")
      dialog(**mix({ class: cls, data: { phlex_kit__dialog_target: "dialog", action: "click->phlex-kit--dialog#backdropClick" } }, @attrs)) do
        yield
        if @show_close_button
          button(type: "button", class: "pk-overlay-close", data: { action: "click->phlex-kit--dialog#dismiss" }) do
            render Icon.new(:x, size: 15)
            span(class: "pk-sr-only") { "Close" }
          end
        end
      end
    end
  end
end
