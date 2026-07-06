module PhlexKit
  # A <template> holding the palette overlay. Like PhlexKit::SheetContent, the
  # phlex-kit--command-dialog controller clones it into <body> on open; the
  # cloned wrapper carries the phlex-kit--command controller (+ the instance
  # marker the outlet selector finds), a click/esc-dismiss backdrop, and the
  # centered panel. See command.rb.
  class CommandDialogContent < BaseComponent
    SIZES = { xs: "xs", sm: "sm", md: nil, lg: "lg", xl: "xl", full: "full" }.freeze

    def initialize(size: :md, aria_label: "Command palette", **attrs)
      @size = size.to_sym
      @aria_label = aria_label
      @attrs = attrs
    end

    def view_template(&block)
      template(data: { phlex_kit__command_dialog_target: "content" }) do
        # The keydown action is the focus trap: Tab cycles within the cloned
        # overlay instead of escaping to the page underneath.
        div(data: {
          controller: "phlex-kit--command",
          phlex_kit__command_dialog_instance: true,
          action: "keydown->phlex-kit--command#trapFocus"
        }) do
          backdrop
          div(**mix({
            class: panel_classes,
            role: "dialog",
            aria: { modal: "true", label: @aria_label },
            data: { state: "open" }
          }, @attrs), &block)
        end
      end
    end

    private

    def panel_classes
      [ "pk-command-dialog", SIZES.fetch(@size) ].compact.join(" ")
    end

    def backdrop
      div(
        class: "pk-command-overlay",
        data: { state: "open", action: "click->phlex-kit--command#dismiss keydown.esc@window->phlex-kit--command#dismiss" }
      )
    end
  end
end
