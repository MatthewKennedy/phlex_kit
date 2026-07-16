module PhlexKit
  # The modal body, held in a <template> and cloned into <body> on open. The
  # cloned div carries its own `phlex-kit--alert-dialog` controller so Cancel
  # (#dismiss) can remove it. Holds Header + Footer. Caller **attrs land on the
  # visible panel (the role="alertdialog" div), not the inert <template>.
  # See alert_dialog.rb.
  class AlertDialogContent < BaseComponent
    # size => panel modifier; :sm is shadcn's compact variant.
    SIZES = { default: nil, sm: "sm" }.freeze

    def initialize(size: :default, **attrs)
      @size = size.to_sym
      @attrs = attrs
    end

    def view_template(&block)
      template(data: { phlex_kit__alert_dialog_target: "content" }) do
        # The clone's controller listens for keydown on `document` while open
        # (an element-scoped listener dies the moment focus escapes to <body>);
        # mousedown on the overlay is prevented so a stray click can't move
        # focus out of the trap. tabindex="-1" on the panel is the focus
        # fallback when the dialog has no focusable children.
        # data-pk-overlay-clone is a common marker read across clone-based
        # overlay families (see #topmost in alert_dialog_controller.js) so
        # Escape resolves to whichever overlay is actually topmost, even when
        # a different overlay type (e.g. a Sheet) is nested/stacked on top.
        div(data: { controller: "phlex-kit--alert-dialog", pk_overlay_clone: "" }) do
          div(class: "pk-alert-dialog-overlay", "aria-hidden": "true", data: { action: "mousedown->phlex-kit--alert-dialog#overlayMousedown" })
          panel_attrs = { class: [ "pk-alert-dialog-panel", fetch_option(SIZES, @size, :size) ].compact.join(" ") }
          # Defaults only when the caller didn't supply their own — `mix`
          # would fuse role="alertdialog dialog" / aria-modal="true false" /
          # tabindex="-1 0" instead of overriding.
          panel_attrs[:role] = "alertdialog" unless attr_set?(:role)
          panel_attrs[:"aria-modal"] = "true" unless aria_key_set?(:modal)
          panel_attrs[:tabindex] = "-1" unless attr_set?(:tabindex)
          div(**mix(panel_attrs, @attrs), &block)
        end
      end
    end
  end
end
