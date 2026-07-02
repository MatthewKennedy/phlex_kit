module PhlexKit
  # The modal body, held in a <template> and cloned into <body> on open. The
  # cloned div carries its own `phlex-kit--alert-dialog` controller so Cancel
  # (#dismiss) can remove it. Holds Header + Footer. See alert_dialog.rb.
  class AlertDialogContent < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      template(**mix({ data: { phlex_kit__alert_dialog_target: "content" } }, @attrs)) do
        div(data: { controller: "phlex-kit--alert-dialog" }) do
          div(class: "pk-alert-dialog-overlay", "aria-hidden": "true")
          div(role: "alertdialog", "aria-modal": "true", class: "pk-alert-dialog-panel", &block)
        end
      end
    end
  end
end
