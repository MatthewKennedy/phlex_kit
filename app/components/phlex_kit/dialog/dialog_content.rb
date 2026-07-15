module PhlexKit
  # The <dialog> box. `size:` picks the width tier (md = shadcn's default
  # max-w-sm); `show_close_button: false` drops the top-right ✕ (their
  # showCloseButton). `labelledby:`/`describedby:` render aria-labelledby /
  # aria-describedby for callers who assign their own ids to DialogTitle /
  # DialogDescription; when absent, the phlex-kit--dialog controller auto-wires
  # them in connect(). See dialog.rb.
  class DialogContent < BaseComponent
    SIZES = { xs: "xs", sm: "sm", md: nil, lg: "lg", xl: "xl", full: "full" }.freeze

    def initialize(size: :md, show_close_button: true, labelledby: nil, describedby: nil, **attrs)
      @size = size.to_sym
      @show_close_button = show_close_button
      @labelledby = labelledby
      @describedby = describedby
      @attrs = attrs
    end

    def view_template(&block)
      cls = [ "pk-dialog", fetch_option(SIZES, @size, :size) ].compact.join(" ")
      aria = {}
      aria[:labelledby] = @labelledby if @labelledby
      aria[:describedby] = @describedby if @describedby
      dialog(**mix({ class: cls, aria: aria, data: { phlex_kit__dialog_target: "dialog", action: "pointerdown->phlex-kit--dialog#backdropPointerdown click->phlex-kit--dialog#backdropClick" } }, @attrs)) do
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
