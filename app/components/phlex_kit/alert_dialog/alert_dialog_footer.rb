module PhlexKit
  # Footer of a PhlexKit::AlertDialog (Cancel + the destructive submit). See alert_dialog.rb.
  class AlertDialogFooter < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({ class: "pk-alert-dialog-footer" }, @attrs), &block)
    end
  end
end
