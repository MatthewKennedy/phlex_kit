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
        div(data: { controller: "phlex-kit--alert-dialog" }) do
          div(class: "pk-alert-dialog-overlay", "aria-hidden": "true", data: { action: "mousedown->phlex-kit--alert-dialog#overlayMousedown" })
          div(**mix({ role: "alertdialog", "aria-modal": "true", tabindex: "-1", class: [ "pk-alert-dialog-panel", fetch_option(SIZES, @size, :size) ].compact.join(" ") }, @attrs), &block)
        end
      end
    end
  end
end
