module PhlexKit
  # The modal body, held in a <template> and cloned into <body> on open. The
  # cloned div carries its own `phlex-kit--alert-dialog` controller so Cancel
  # (#dismiss) can remove it. Holds Header + Footer. See alert_dialog.rb.
  class AlertDialogContent < BaseComponent
    # size => panel modifier; :sm is shadcn's compact variant.
    SIZES = { default: nil, sm: "sm" }.freeze

    def initialize(size: :default, **attrs)
      @size = size.to_sym
      @attrs = attrs
    end

    def view_template(&block)
      template(**mix({ data: { phlex_kit__alert_dialog_target: "content" } }, @attrs)) do
        div(data: { controller: "phlex-kit--alert-dialog" }) do
          div(class: "pk-alert-dialog-overlay", "aria-hidden": "true")
          div(role: "alertdialog", "aria-modal": "true", class: [ "pk-alert-dialog-panel", fetch_option(SIZES, @size, :size) ].compact.join(" "), &block)
        end
      end
    end
  end
end
