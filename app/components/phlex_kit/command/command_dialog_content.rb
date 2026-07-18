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
        # data-pk-overlay-clone is the common marker stamped by every
        # clone-based overlay family (see alert_dialog_controller.js#topmost):
        # it lets stacked overlays of DIFFERENT types resolve which one is
        # topmost, so one Escape never closes both layers at once.
        div(data: {
          controller: "phlex-kit--command",
          phlex_kit__command_dialog_instance: true,
          pk_overlay_clone: "",
          action: "keydown->phlex-kit--command#trapFocus"
        }) do
          backdrop
          panel_attrs = { class: panel_classes, data: { state: "open" } }
          # Defaults only when the caller didn't supply their own — `mix`
          # would fuse role="dialog x" / aria-modal="true false" (same guard
          # as AlertDialogContent/SheetContent/DrawerContent, round 7).
          panel_attrs[:role] = "dialog" unless attr_set?(:role)
          aria = {}
          aria[:modal] = "true" unless aria_key_set?(:modal)
          aria[:label] = @aria_label unless aria_labelled?
          panel_attrs[:aria] = aria unless aria.empty?
          div(**mix(panel_attrs, @attrs), &block)
        end
      end
    end

    private

    def panel_classes
      [ "pk-command-dialog", fetch_option(SIZES, @size, :size) ].compact.join(" ")
    end

    def backdrop
      div(
        class: "pk-command-overlay",
        data: { state: "open", action: "click->phlex-kit--command#dismiss keydown.esc@window->phlex-kit--command#dismiss" }
      )
    end
  end
end
