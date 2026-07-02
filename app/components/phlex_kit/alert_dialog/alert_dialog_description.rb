module PhlexKit
  # Body text of a PhlexKit::AlertDialog. See alert_dialog.rb.
  class AlertDialogDescription < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      p(**mix({ class: "pk-alert-dialog-description" }, @attrs), &block)
    end
  end
end
