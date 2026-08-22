module PhlexKit
  # A <template> holding the palette overlay. Like PhlexKit::SheetContent, the
  # phlex-kit--command-dialog controller clones it into <body> on open; the
  # cloned wrapper carries the phlex-kit--command controller (+ the instance
  # marker the outlet selector finds), a click/esc-dismiss backdrop, and the
  # centered panel. See command.rb.
  class CommandDialogContent < BaseComponent
    SIZES = { xs: "xs", sm: "sm", md: nil, lg: "lg", xl: "xl", full: "full" }.freeze

    DEFAULT_LABEL = "Command palette"

    def initialize(size: :md, labelledby: nil, describedby: nil, **attrs)
      # aria_label: was the API through 0.15.0 — overlays now name themselves
      # with labelledby:/describedby: like every other overlay content. A bare
      # accessible name still rides attrs, same as anywhere else in the kit.
      if attrs.key?(:aria_label) || attrs.key?("aria_label")
        raise ArgumentError, "CommandDialogContent does not support aria_label: — pass aria: { label: \"…\" }, or labelledby: for an id reference"
      end
      @size = size.to_sym
      @labelledby = labelledby
      @describedby = describedby
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
          aria[:labelledby] = @labelledby if @labelledby
          aria[:describedby] = @describedby if @describedby
          # Falls back to a default name only when nothing else names it.
          aria[:label] = DEFAULT_LABEL unless @labelledby || aria_labelled?
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
